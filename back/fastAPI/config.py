from sqlalchemy import create_engine, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os
from urllib.parse import quote_plus
import pymysql

# 환경 변수 로드
load_dotenv(override=True)

# MySQL 연결 정보
MYSQL_USER = os.getenv('MYSQL_USER')
MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD')
MYSQL_HOST = os.getenv('MYSQL_HOST')
MYSQL_PORT = os.getenv('MYSQL_PORT')
MYSQL_DATABASE = os.getenv('MYSQL_DATABASE')

# MySQL 연결 테스트
def test_mysql_connection():
    try:
        connection = pymysql.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD,
            database=MYSQL_DATABASE,
            port=int(MYSQL_PORT)
        )
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            print("Direct MySQL connection successful!")
        connection.close()
        return True
    except Exception as e:
        print(f"MySQL connection failed: {str(e)}")
        return False

# SQLAlchemy 데이터베이스 URL
SQLALCHEMY_DATABASE_URL = f"mysql+pymysql://{MYSQL_USER}:{quote_plus(MYSQL_PASSWORD)}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}?charset=utf8mb4"

# SQLAlchemy 엔진 생성
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_pre_ping=True,
    pool_recycle=3600,
    echo=True,
    pool_size=5,
    max_overflow=10
)

# 세션 생성
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
    expire_on_commit=False
)

# Base 클래스 생성
Base = declarative_base()

# SQLAlchemy 연결 테스트
def test_sqlalchemy_connection():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            print("SQLAlchemy connection successful!")
            return True
    except Exception as e:
        print(f"SQLAlchemy connection failed: {str(e)}")
        return False

# 데이터베이스 세션 의존성
def get_db():
    db = SessionLocal()
    try:
        db.execute(text("SELECT 1"))
        yield db
    except Exception as e:
        print(f"Database session error: {str(e)}")
        db.rollback()
        raise
    finally:
        db.close()

# 초기 연결 테스트
if __name__ == "__main__":
    print("Testing MySQL connection...")
    if test_mysql_connection():
        print("Testing SQLAlchemy connection...")
        test_sqlalchemy_connection()
    else:
        print("Failed to connect to MySQL. Please check your connection settings.") 