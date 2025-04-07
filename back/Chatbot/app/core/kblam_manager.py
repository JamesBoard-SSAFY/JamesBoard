# app/core/kblam_manager.py

import logging
from typing import List, Dict, Any, Optional
from app.models.knowledge import KnowledgeTriple
from app.db.vector_store import get_chroma_client

# 로거 설정
logger = logging.getLogger(__name__)

class SimplifiedKBLaM:
    """
    벡터 스토어의 검색 결과에서 동적으로 트리플을 생성하는
    간소화된 KBLaM 구현
    """
    def __init__(self, top_k: int = 5):
        # 상위 k개 결과 설정
        self.top_k = top_k
        # ChromaDB 클라이언트 초기화
        logger.info("ChromaDB 클라이언트 초기화 중...")
        self.chroma_client = get_chroma_client()
        # 보드게임 컬렉션 가져오기
        logger.info("ChromaDB 컬렉션 가져오는 중...")
        self.collection = self.chroma_client.get_collection("langchain")
        logger.info(f"컬렉션 정보: {self.collection.count()} 항목 있음")
    
    def retrieve_relevant_triples(self, query: str) -> List[KnowledgeTriple]:
        """
        벡터 스토어에서 관련 게임 메타데이터를 검색하고 트리플로 변환
        """
        # E5 모델 형식에 맞게 쿼리 포맷팅
        formatted_query = f"query: {query}"
        logger.debug(f"포맷된 쿼리: {formatted_query}")
        
        # 벡터 스토어 검색
        logger.debug(f"벡터 스토어 검색 시작, top_k={self.top_k}")
        results = self.collection.query(
            query_texts=[formatted_query],
            n_results=self.top_k
        )
        
        # 검색 결과 로깅
        logger.debug(f"검색 결과 키: {list(results.keys())}")
        
        # 검색 결과에서 메타데이터 추출
        metadatas = results['metadatas'][0] if 'metadatas' in results and results['metadatas'] else []
        documents = results.get('documents', [[]])[0] if 'documents' in results else []
        
        logger.debug(f"메타데이터 개수: {len(metadatas)}")
        if metadatas:
            logger.debug(f"첫 번째 메타데이터 키: {list(metadatas[0].keys()) if metadatas[0] else '없음'}")
        if documents:
            logger.debug(f"첫 번째 문서 일부: {documents[0][:100] if documents[0] else '없음'}")
        
        # 메타데이터에서 동적으로 트리플 생성
        triples = []
        for metadata in metadatas:
            game_title = metadata.get('game_Title') or metadata.get('name') or metadata.get('title')
            if not game_title:
                logger.warning(f"게임 제목이 없는 메타데이터: {metadata}")
                continue
                
            logger.debug(f"게임 '{game_title}'에 대한 메타데이터 처리 중")
            for key, value in metadata.items():
                if key in ['game_Title', 'name', 'title'] or value is None or value == '':
                    continue
                    
                # 필요시 값을 문자열로 변환
                if not isinstance(value, str):
                    if isinstance(value, list):
                        value = ', '.join(value)
                    else:
                        value = str(value)
                        
                triples.append(KnowledgeTriple(
                    entity=game_title,
                    attribute=key,
                    value=value
                ))
                logger.debug(f"트리플 생성: {game_title} - {key} - {value[:30] if len(value) > 30 else value}")
        
        logger.info(f"생성된 트리플 수: {len(triples)}")
        return triples
    
    def format_context(self, triples: List[KnowledgeTriple]) -> str:
        """
        LLM에 전달할 컨텍스트 문자열로 트리플 포맷팅
        """
        context_lines = [f"The {t.attribute} of {t.entity} is {t.value}." for t in triples]
        return "\n".join(context_lines)
    
    def predict(self, query: str, llm_client, system_prompt: str, pre_retrieved_triples=None) -> str:
        """
        지식 트리플을 컨텍스트로 사용하여 LLM으로 응답 생성
        
        Args:
            query: 사용자 질문
            llm_client: LLM 클라이언트
            system_prompt: 시스템 프롬프트
            pre_retrieved_triples: 이미 검색된 트리플 (있는 경우 재사용)
        
        Returns:
            LLM의 응답 텍스트
        """
        # 이미 검색된 트리플이 있으면 재사용, 없으면 새로 검색
        relevant_triples = pre_retrieved_triples if pre_retrieved_triples else self.retrieve_relevant_triples(query)
        
        # 컨텍스트 포맷팅
        kb_context = self.format_context(relevant_triples)
        
        # LLM 호출
        response = llm_client.generate(
            system_prompt=system_prompt,
            user_prompt=f"Knowledge Base:\n{kb_context}\n\nUser Question: {query}"
        )
        
        return response