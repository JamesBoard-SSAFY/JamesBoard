# app/api/auth.py
import logging
from fastapi import APIRouter, Request, HTTPException, Depends
from typing import Dict, Any
from app.utils.auth import get_user_id_from_token

# 로거 설정
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

# 인증 관련 라우터
router = APIRouter()

@router.get("/auth/login")
async def login():
    """스프링 부트 인증 시스템으로 리디렉션"""
    logger.debug("로그인 엔드포인트 호출됨")
    return {
        "message": "로그인이 필요합니다",
        "login_url": "/api/auth/token"
    }


@router.get("/auth/token")
async def token_info():
    """토큰 발급 정보"""
    logger.debug("토큰 정보 엔드포인트 호출됨")
    return {
        "message": "토큰은 Spring Boot 서버에서 발급받아야 합니다"
    }

@router.get("/auth/me")
async def get_my_info(
    request: Request
):
    """현재 사용자 정보 반환"""
    logger.debug("get_my_info 엔드포인트 호출됨")
    
    # 헤더에서 토큰 추출
    authorization = request.headers.get("Authorization")
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="인증 정보가 없습니다")
    
    token = authorization.split(" ")[1]
    user_id = get_user_id_from_token(authorization)
    
    # 예시 응답
    return {
        "user_id": user_id,
        "username": f"user_{user_id}",
        "email": f"user{user_id}@example.com"
    }