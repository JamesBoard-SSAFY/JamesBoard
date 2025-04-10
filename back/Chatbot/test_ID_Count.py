# test_count_unique_game_titles.py
import os
import logging
from app.db.vector_store import get_chroma_client

# 로깅 설정
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def count_unique_game_titles():
    try:
        logger.info("ChromaDB에 연결 중...")
        client = get_chroma_client()
        
        # 모든 컬렉션 나열
        collections = client.list_collections()
        
        # 모든 게임 제목을 저장할 집합 (중복 제거)
        all_unique_game_titles = set()
        total_items_count = 0
        items_with_title_count = 0
        
        if collections:
            logger.info(f"ChromaDB 컬렉션 수: {len(collections)}개")
            
            for collection_name in collections:
                try:
                    # 컬렉션 가져오기
                    collection = client.get_collection(collection_name)
                    items_count = collection.count()
                    total_items_count += items_count
                    
                    logger.info(f"컬렉션 '{collection_name}' 처리 중 (항목 수: {items_count})")
                    
                    # 컬렉션의 모든 항목 가져오기
                    if items_count > 0:
                        result = collection.get()
                        metadatas = result.get('metadatas', [])
                        
                        # 게임 제목 추출 및 중복 제거
                        for metadata in metadatas:
                            if not metadata:
                                continue
                                
                            game_title = metadata.get('game_Title') or metadata.get('name') or metadata.get('title')
                            
                            if not game_title:
                                logger.debug(f"게임 제목이 없는 메타데이터: {metadata}")
                                continue
                                
                            items_with_title_count += 1
                            all_unique_game_titles.add(game_title)
                    
                except Exception as e:
                    logger.error(f"컬렉션 '{collection_name}' 처리 중 오류: {e}")
            
            # 결과 출력
            logger.info(f"\n총 항목 수: {total_items_count}")
            logger.info(f"제목이 있는 항목 수: {items_with_title_count}")
            logger.info(f"고유 게임 제목 수: {len(all_unique_game_titles)}")
            
            # 고유 게임 제목 샘플 출력 (최대 20개)
            if all_unique_game_titles:
                sample_size = min(20, len(all_unique_game_titles))
                sample_titles = list(all_unique_game_titles)[:sample_size]
                logger.info(f"\n고유 게임 제목 샘플 ({sample_size}개):")
                for i, title in enumerate(sample_titles, 1):
                    logger.info(f"{i}. {title}")
        else:
            logger.warning("ChromaDB에 컬렉션이 없습니다!")
        
        # ChromaDB 저장 경로 확인
        chroma_path = os.getenv("CHROMA_PERSIST_DIR", os.path.join("data", "chroma_db"))
        logger.info(f"\nChromaDB 경로: {os.path.abspath(chroma_path)}")
        
    except Exception as e:
        logger.error(f"오류 발생: {e}")

if __name__ == "__main__":
    count_unique_game_titles()