# Python 3.10 슬림 버전 사용
FROM python:3.10-slim

# 작업 디렉토리 생성
WORKDIR /app

# 의존성 파일만 먼저 복사
COPY requirements.txt .

# pip 업그레이드 및 패키지 설치
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 나머지 소스 코드 복사
COPY . .

EXPOSE 9099

# FastAPI 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9099"]