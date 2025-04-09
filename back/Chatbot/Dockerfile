FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && pip install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# main.py는 app 안에 있으므로 app 디렉토리만 복사
COPY app ./app

# PYTHONPATH 설정
ENV PYTHONPATH=/app

EXPOSE 9098

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "9098"]
