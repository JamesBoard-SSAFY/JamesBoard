# app/api/chat.py
from fastapi import APIRouter, Request, HTTPException
from pydantic import BaseModel
from typing import Dict, Any, List, Optional
from app.services.chat_service import ChatService
import logging
from app.utils.auth import get_user_id_from_token

logger = logging.getLogger(__name__)

# 라우터 설정
router = APIRouter()
chat_service = ChatService()  # 싱글톤 인스턴스 사용

class ChatRequest(BaseModel):
    """채팅 요청 모델"""
    query: str

class ChatResponse(BaseModel):
    """채팅 응답 모델"""
    gameId: Optional[int] = None
    chatType: int = 0  # 0: 일반모드, 1: 추천모드, 2: 비교모드
    message: str
    thumbnail: Optional[str] = None

    class Config:
        schema_extra = {
            "example": {
                "gameId": 1,
                "chatType": 0,
                "message": "카탄은 자원 관리가 중요한 전략 게임입니다.",
                "thumbnail": "https://example.com/images/davinci.jpg"
            }
        }

@router.post("/chat")
async def chat_endpoint(
    chat_request: ChatRequest, 
    request: Request
):
    """
    채팅 엔드포인트 - 보드게임 질문에 응답합니다.
    Authorization 헤더에 Bearer 토큰이 필요합니다.
    """
    try:
        # 헤더에서 토큰 추출
        authorization = request.headers.get("Authorization")
        if not authorization or not authorization.startswith("Bearer "):
            raise HTTPException(status_code=401, detail="인증 정보가 없습니다")
        
        user_id = get_user_id_from_token(authorization)
        
        # ChatService 사용하여 응답 생성
        service_response = await chat_service.handle_chat(
            query=chat_request.query,
            user_id=user_id
        )
        
        # 채팅 타입 코드 변환: 문자열 -> 숫자
        chat_type_code = 0  # 기본값 (일반모드)
        
        # 쿼리에서 키워드 검사
        query = chat_request.query.lower()
        if "추천" in query:
            chat_type_code = 1  # 추천모드
        elif "비교" in query or service_response.get("chat_type") == "comparison":
            chat_type_code = 2  # 비교모드
        
        # 새 응답 형식으로 변환
        response = {
            "chatType": chat_type_code,
            "message": service_response.get("message", "")
        }
        
        # 추천모드인 경우에만 thumbnail과 gameId 추가
        if chat_type_code == 1:
            response["thumbnail"] = service_response.get("thumbnail")
            # 임시 gameId (실제로는 서비스에서 가져와야 함)
            response["gameId"] = service_response.get("gameId") 
        else:
            response["thumbnail"] = None
            response["gameId"] = None
        
        return response
    except Exception as e:
        import traceback
        error_trace = traceback.format_exc()
        logger.error(f"채팅 처리 중 오류: {str(e)}\n{error_trace}")
        raise HTTPException(status_code=500, detail=f"내부 서버 오류: {str(e)}")

@router.get("/chat/history")
async def get_chat_history(
    request: Request
):
    """
    사용자 채팅 기록을 조회합니다.
    Authorization 헤더에 Bearer 토큰이 필요합니다.
    """
    # 헤더에서 토큰 추출
    authorization = request.headers.get("Authorization")
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="인증 정보가 없습니다")
    
    user_id = get_user_id_from_token(authorization)
    
    # ChatService를 통해 채팅 기록 조회
    history = await chat_service.get_user_chat_history(user_id)
    
    return {
        "user_id": user_id,
        "history": history
    }

@router.get("/chat/recommendations")
async def get_recommendations(
    request: Request
):
    """
    게임 추천을 조회합니다.
    Authorization 헤더에 Bearer 토큰이 필요합니다.
    """
    # 헤더에서 토큰 추출
    authorization = request.headers.get("Authorization")
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="인증 정보가 없습니다")
    
    user_id = get_user_id_from_token(authorization)
    
    # ChatService를 통해 개인화된 추천 가져오기
    recommendations = await chat_service.get_personalized_recommendations(user_id)
    
    return {
        "user_id": user_id,
        "personalized": True,
        "recommendations": recommendations
    }