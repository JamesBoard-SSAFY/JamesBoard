from sqlalchemy import Column, Integer, Float, DateTime, String, Text, BigInteger, ForeignKey, JSON, Boolean, Date, UniqueConstraint
from sqlalchemy.orm import relationship
from config import Base
from datetime import datetime

class Game(Base):
    __tablename__ = "game"

    game_id = Column(Integer, primary_key=True, index=True)
    game_rank = Column(Integer)
    game_title = Column(String(255))
    game_description = Column(Text)
    big_thumbnail = Column(String(255))
    small_thumbnail = Column(String(255))
    game_image = Column(String(255))
    game_year = Column(Integer)
    min_player = Column(Integer)
    max_player = Column(Integer)
    game_play_time = Column(Integer)
    game_min_age = Column(Integer)
    game_publisher = Column(String(255))
    game_difficulty = Column(String(50))
    game_avg_rating = Column(Float)
    game_review_count = Column(Integer)

    # 관계 설정
    recommendations = relationship("Recommend", back_populates="game")
    recommend_contents = relationship("RecommendContent", back_populates="game", foreign_keys="RecommendContent.game_id")
    user_activities = relationship("UserActivity", back_populates="game")

    def __repr__(self):
        return f"<Game {self.game_title}>"

class Recommend(Base):
    __tablename__ = "recommend"
    
    recommend_id = Column(BigInteger, primary_key=True, autoincrement=True)
    recommend_at = Column(DateTime(6))
    recommend_rank = Column(Integer)
    game_id = Column(BigInteger, ForeignKey("game.game_id"))
    user_id = Column(BigInteger, ForeignKey("users.user_id"))
    
    # 관계 설정
    game = relationship("Game", back_populates="recommendations")
    user = relationship("User", back_populates="recommendations")

    def __repr__(self):
        return f"<Recommend {self.recommend_id}>"

class RecommendContent(Base):
    __tablename__ = "recommend_content"
    
    recommend_content_id = Column(BigInteger, primary_key=True, autoincrement=True)
    game_id = Column(BigInteger, ForeignKey("game.game_id"))
    recommend_game_id = Column(BigInteger, ForeignKey("game.game_id"))
    recommend_content_rank = Column(BigInteger)

    # 관계 설정
    game = relationship("Game", back_populates="recommend_contents", foreign_keys=[game_id])
    recommend_game = relationship("Game", foreign_keys=[recommend_game_id])

    def __repr__(self):
        return f"<RecommendContent {self.recommend_content_id}>"

class UserActivity(Base):
    __tablename__ = 'user_activity'
    
    user_activity_id = Column(BigInteger, primary_key=True, autoincrement=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    modified_at = Column(DateTime(6))
    user_activity_rating = Column(Float)
    user_activity_time = Column(Integer)
    game_id = Column(BigInteger, ForeignKey('game.game_id'), nullable=False)
    user_id = Column(BigInteger, ForeignKey('users.user_id'), nullable=False)
    
    # 관계 설정
    game = relationship("Game", back_populates="user_activities")
    user = relationship("User", back_populates="user_activities")
    
    # 복합 유니크 제약조건
    __table_args__ = (
        UniqueConstraint('user_id', 'game_id', name='uix_user_game'),
    )
    
    def __repr__(self):
        return f"<UserActivity {self.user_activity_id}>"

class User(Base):
    __tablename__ = "users"

    user_id = Column(BigInteger, primary_key=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    login_id = Column(String(255))
    user_nickname = Column(String(255))
    user_profile = Column(String(255))
    prefer_game_id = Column(BigInteger, ForeignKey("game.game_id"), unique=True)
    
    # 관계 설정
    recommendations = relationship("Recommend", back_populates="user")
    user_activities = relationship("UserActivity", back_populates="user")
    
    def __repr__(self):
        return f"<User {self.user_nickname}>" 