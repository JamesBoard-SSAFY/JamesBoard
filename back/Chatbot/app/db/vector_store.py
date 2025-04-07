# ChromaDB 벡터 저장소 연결

# boardgame-assistant/app/db/vector_store.py

import os
import chromadb
from chromadb.config import Settings
from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import HuggingFaceEmbeddings

def get_embedding_function():
    """임베딩 함수 가져오기"""
    # HuggingFace 임베딩 모델 설정
    model_name = "jhgan/ko-sroberta-multitask"
    model_kwargs = {'device': 'cpu'}
    encode_kwargs = {'normalize_embeddings': True}
    
    # 임베딩 함수 생성
    embeddings = HuggingFaceEmbeddings(
        model_name=model_name,
        model_kwargs=model_kwargs,
        encode_kwargs=encode_kwargs
    )
    
    return embeddings

def get_chroma_client():
    """ChromaDB 클라이언트 가져오기 또는 생성"""
    # 크로마DB 경로 설정
    chroma_path = os.getenv("CHROMA_PERSIST_DIR", os.path.join("data", "chroma_db"))
    os.makedirs(chroma_path, exist_ok=True)
    
    # 클라이언트 생성
    client = chromadb.PersistentClient(
        path=chroma_path,
        settings=Settings(
            anonymized_telemetry=False,
            allow_reset=True
        )
    )
    
    return client

def get_vector_store():
    """Langchain Chroma 벡터 저장소 가져오기"""
    # 크로마DB 경로 설정
    chroma_path = os.getenv("CHROMA_PERSIST_DIR", os.path.join("data", "chroma_db"))
    os.makedirs(chroma_path, exist_ok=True)
    
    # 임베딩 함수 가져오기
    embedding_function = get_embedding_function()
    
    # Chroma 벡터 저장소 생성
    vectorstore = Chroma(
        persist_directory=chroma_path,
        embedding_function=embedding_function
    )
    
    return vectorstore