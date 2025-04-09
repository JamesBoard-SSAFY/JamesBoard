# # app/middleware/auth_middleware.py
# from fastapi import Request, HTTPException
# from starlette.middleware.base import BaseHTTPMiddleware
# import jwt
# import os
# from dotenv import load_dotenv
# load_dotenv()  # .env 파일에서 환경 변수 로드

# class JWTAuthMiddleware(BaseHTTPMiddleware):
#     def __init__(self, app, exclude_paths=None):
#         super().__init__(app)
#         self.exclude_paths = exclude_paths or []
#         self.secret_key = os.getenv("JWT_SECRET", "s8dF4jKl2mP9qR7tZ5xV3wY1bN6cA0uE")
#         self.algorithm = "HS256"

#     async def dispatch(self, request: Request, call_next):
#         # 제외 경로 확인
#         path = request.url.path
#         if any(path.startswith(prefix) for prefix in self.exclude_paths):
#             return await call_next(request)

#         # Authorization 헤더 추출
#         authorization = request.headers.get("Authorization")
#         if not authorization or not authorization.startswith("Bearer "):
#             raise HTTPException(status_code=401, detail="인증 정보가 없거나 형식이 잘못되었습니다")

#         token = authorization.split(" ")[1]
#         try:
#             # 토큰 검증
#             payload = jwt.decode(token, self.secret_key, algorithms=[self.algorithm])
            
#             # userId 확인
#             if "userId" not in payload:
#                 raise HTTPException(status_code=401, detail="토큰에 사용자 ID 정보가 없습니다")
            
#             # request.state에 사용자 ID 저장 (필요시 사용 가능)
#             if not hasattr(request.state, "user_id"):
#                 request.state.__dict__["user_id"] = payload["userId"]
#             else:
#                 request.state.user_id = payload["userId"]
            
#         except jwt.ExpiredSignatureError:
#             raise HTTPException(status_code=401, detail="토큰이 만료되었습니다")
#         except jwt.InvalidTokenError:
#             raise HTTPException(status_code=401, detail="유효하지 않은 토큰입니다")
#         except jwt.PyJWTError:
#             raise HTTPException(status_code=401, detail="인증 자격 증명이 유효하지 않습니다")
        
#         # 다음 미들웨어 또는 엔드포인트 실행
#         return await call_next(request)