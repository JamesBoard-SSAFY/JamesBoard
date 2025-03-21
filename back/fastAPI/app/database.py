from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session
import urllib.parse

user_name = "root"
# 개인 비밀번호라 없애놓음
user_pwd = ""
encoded_password = urllib.parse.quote(user_pwd)
user_host = "localhost"
db_name = "D205"

DATABASE = f'mysql+mysqlconnector://{user_name}:{encoded_password}@{user_host}/{db_name}'


ENGINE = create_engine(DATABASE)

session = scoped_session(
    sessionmaker(
        autocommit=False,
        autoflush=False,
        bind=ENGINE
    )
)

Base = declarative_base()
Base.query = session.query_property()

# import pandas as pd
# from sqlalchemy import create_engine, text
# import urllib.parse

# password = "Formylord2018!@"
# encoded_password = urllib.parse.quote(password)

# engine = create_engine(f'mysql+mysqlconnector://root:{encoded_password}@localhost/D205')

# try:
#     # 데이터베이스 연결 확인
#     with engine.connect() as connection:
#         print("✅ MySQL 연결 성공!")
# except Exception as e:
#     print("❌ MySQL 연결 실패:", e)