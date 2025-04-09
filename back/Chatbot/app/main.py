# app/main.py
import os
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.openapi.utils import get_openapi
from fastapi.security import HTTPBearer
from app.api.chat import router as chat_router
from app.api.auth import router as auth_router
import logging
# auth_check 엔드포인트에서 사용되는 의존성 가져오기
from app.utils.auth import get_user_id_from_token

# .env 파일 로드
load_dotenv()

# 로깅 설정
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# 환경 변수 로드 확인
logger.debug(f"OPENAI_API_KEY 설정 여부: {'설정됨' if os.getenv('OPENAI_API_KEY') else '설정되지 않음'}")

# FastAPI 앱 생성
app = FastAPI(title="보드게임 어시스턴트 API")

logger.debug("FastAPI 앱 생성됨")

# 보안 스키마 설정
security_scheme = HTTPBearer()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8000",
        "http://localhost:9000",
        "http://localhost:8080",
        "http://j12d205.p.ssafy.io:9090",
        "https://j12d205.p.ssafy.io"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["Authorization"],
)

logger.debug("CORS 미들웨어 추가됨")

# 라우터 등록
app.include_router(chat_router, prefix="/fastapi", tags=["chat"])
app.include_router(auth_router, prefix="/fastapi", tags=["auth"])
logger.debug("라우터 등록됨")

# 커스텀 OpenAPI 스키마 정의
def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    
    openapi_schema = get_openapi(
        title="보드게임 어시스턴트 API",
        version="1.0",
        description="Spring Boot JWT 토큰과 호환되는 보드게임 어시스턴트 API",
        routes=app.routes,
    )
    
    # 보안 스키마 추가
    openapi_schema["components"] = openapi_schema.get("components", {})
    openapi_schema["components"]["securitySchemes"] = {
        "bearerAuth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT",
            "description": "Spring Boot에서 발급받은 JWT 토큰을 입력하세요."
        }
    }
    
    # 모든 경로에 보안 요구사항 추가
    openapi_schema["security"] = [{"bearerAuth": []}]
    
    app.openapi_schema = openapi_schema
    return app.openapi_schema

# OpenAPI 스키마 사용자 정의 함수 등록
app.openapi = custom_openapi
logger.debug("OpenAPI 스키마 사용자 정의 완료")

@app.get("/")
async def root():
    """루트 경로 (인증 불필요)"""
    logger.debug("루트 엔드포인트 호출됨")
    return {"message": "보드게임 어시스턴트 API"}

# 인증 확인용 엔드포인트 수정
@app.get("/fastapi/auth-check")
async def auth_check(
    user_id: int = Depends(get_user_id_from_token)
):
    """현재 인증 상태 확인"""
    logger.debug(f"auth-check 엔드포인트 호출됨, user_id: {user_id}")
    return {
        "authenticated": True,
        "user_id": user_id
    }

if __name__ == "__main__":
    import uvicorn
    logger.info("서버 시작 중...")
    uvicorn.run("app.main:app", host="0.0.0.0", port=9000, reload=True)