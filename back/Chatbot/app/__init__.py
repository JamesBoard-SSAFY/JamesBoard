import os
from pathlib import Path
from dotenv import load_dotenv

# 환경 변수 로드
env_path = Path(__file__).parent.parent / ".env"
load_dotenv(dotenv_path=env_path)

# 중요 환경 변수 확인
required_env_vars = [
    "OPENAI_API_KEY", 
    "CHROMA_PERSIST_DIR", 
    "EMBEDDING_MODEL_NAME"
]

missing_vars = [var for var in required_env_vars if not os.getenv(var)]
if missing_vars:
    print(f"⚠️ 경고: 다음 필수 환경 변수가 없습니다: {', '.join(missing_vars)}")