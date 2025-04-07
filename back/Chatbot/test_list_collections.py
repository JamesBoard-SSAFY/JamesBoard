# test_list_collections.py
import os
from app.db.vector_store import get_chroma_client

def list_collections():
    try:
        print("ChromaDB에 연결 중...")
        client = get_chroma_client()
        
        # 모든 컬렉션 나열
        collections = client.list_collections()
        
        if collections:
            print(f"사용 가능한 컬렉션 ({len(collections)}개):")
            for i, collection_name in enumerate(collections):
                print(f"{i+1}. 이름: {collection_name}")
                
                # 컬렉션 정보 확인 (선택적)
                try:
                    collection_info = client.get_collection(collection_name)
                    count = collection_info.count()
                    print(f"   - 항목 수: {count}")
                    
                    # 샘플 데이터 확인 (선택적)
                    if count > 0:
                        sample = collection_info.peek(limit=1)
                        print(f"   - 샘플 메타데이터: {sample.get('metadatas', [])}")
                except Exception as e:
                    print(f"   - 정보 가져오기 실패: {e}")
        else:
            print("컬렉션이 없습니다!")
            
        # ChromaDB 저장 경로 확인
        chroma_path = os.getenv("CHROMA_PERSIST_DIR", os.path.join("data", "chroma_db"))
        print(f"ChromaDB 경로: {os.path.abspath(chroma_path)}")
        
    except Exception as e:
        print(f"오류 발생: {e}")

if __name__ == "__main__":
    list_collections()