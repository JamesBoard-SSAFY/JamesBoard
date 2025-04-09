# 채팅 관련 모델
# boardgame-assistant/app/api/chat.py

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel
from typing import Dict, Any, List, Optional
from app.services.chat_service import ChatService
from app.utils.auth import verify_jwt

# 라우터 설정
router = APIRouter()
security = HTTPBearer()
chat_service = ChatService()

class ChatRequest(BaseModel):
    """채팅 요청 모델"""
    query: str
    chat_type: Optional[str] = "general"

class ChatResponse(BaseModel):
    """채팅 응답 모델"""
    response: str
    games: List[Dict[str, Any]] = []

@router.post("/chat", response_model=ChatResponse)
async def chat_endpoint(
    request: ChatRequest,
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    """
    채팅 엔드포인트 - 보드게임 질문에 응답
    """
    try:
        # JWT 토큰 검증
        verify_jwt(credentials.credentials)
        
        # 채팅 요청 처리
        result = await chat_service.handle_chat(
            query=request.query,
            chat_type=request.chat_type
        )
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))