# app/utils/auth.py
import os
import jwt
import logging
from fastapi import HTTPException, Depends, Request, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Optional

# 로거 설정
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG)

# JWT 설정
SECRET_KEY = os.getenv("JWT_SECRET", "s8dF4jKl2mP9qR7tZ5xV3wY1bN6cA0uE")
ALGORITHM = "HS256"

# HTTP 인증을 위한 bearer 토큰 핸들러
security = HTTPBearer()

def verify_jwt(token: str) -> dict:
    """JWT 토큰을 검증하고 페이로드를 반환"""
    logger.debug(f"검증 중인 토큰: {token[:10]}...")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        logger.debug(f"토큰 페이로드: {payload}")
        return payload
    except jwt.ExpiredSignatureError:
        logger.error("토큰 만료")
        raise HTTPException(status_code=401, detail="토큰이 만료되었습니다")
    except jwt.InvalidTokenError:
        logger.error("유효하지 않은 토큰")
        raise HTTPException(status_code=401, detail="유효하지 않은 토큰입니다")
    except jwt.PyJWTError as e:
        logger.error(f"JWT 오류: {str(e)}")
        raise HTTPException(status_code=401, detail="인증 자격 증명이 유효하지 않습니다")
    except Exception as e:
        logger.error(f"예상치 못한 오류: {str(e)}")
        raise HTTPException(status_code=401, detail=f"인증 검증 중 오류: {str(e)}")

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(security)) -> int:
    """토큰 검증 후 사용자 ID 반환"""
    logger.debug("get_current_user_id 호출됨")
    token = credentials.credentials
    payload = verify_jwt(token)
    
    # Spring Boot 토큰에서는 'userId' 클레임 사용
    user_id = payload.get("userId")
    logger.debug(f"클레임에서 추출한 userId: {user_id}")
    if user_id is None:
        logger.error("토큰에 userId 클레임 없음")
        raise HTTPException(status_code=401, detail="토큰에 사용자 ID 정보가 없습니다")
    
    return user_id

def get_user_id_from_token(authorization: str = Header(None)):
    """헤더에서 직접 토큰을 추출하여 사용자 ID 반환"""
    logger.debug(f"get_user_id_from_token 호출됨, 헤더: {authorization[:20] if authorization else None}")
    if not authorization or not authorization.startswith("Bearer "):
        logger.error("인증 헤더 형식 오류")
        raise HTTPException(status_code=401, detail="인증 정보가 없거나 형식이 잘못되었습니다")
        
    token = authorization.split(" ")[1]
    try:
        logger.debug(f"토큰 디코딩 시작: {token[:10]}...")
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        
        logger.debug(f"토큰 페이로드: {payload}")
        if "userId" not in payload:
            logger.error("토큰에 userId 클레임 없음")
            raise HTTPException(status_code=401, detail="토큰에 사용자 ID 정보가 없습니다")
            
        user_id = payload["userId"]
        logger.debug(f"추출된 userId: {user_id}")
        return user_id
    except Exception as e:
        logger.error(f"토큰 처리 중 오류: {str(e)}")
        raise HTTPException(status_code=401, detail=f"인증 오류: {str(e)}")