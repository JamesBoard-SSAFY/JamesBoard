from sqlalchemy import Column, Integer, Float, DateTime, String, Text, BigInteger, ForeignKey, JSON
from sqlalchemy.orm import relationship
from config import Base
import enum
from datetime import datetime

class Game(Base):
    __tablename__ = "game"

    game_id = Column(BigInteger, primary_key=True, autoincrement=True)
    game_rank = Column(Integer)
    game_title = Column(String(255), nullable=False)
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
    game_difficulty = Column(Integer)
    game_avg_rating = Column(Float)
    game_review_count = Column(Integer)
    # game_created_at = Column(DateTime, default=datetime.now)
    # game_updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)

    def __repr__(self):
        return f"<Game {self.game_title}>"

class GameRecommendation(Base):
    __tablename__ = "game_recommendations"
    
    recommend_id = Column(BigInteger, primary_key=True, autoincrement=True)
    game_id = Column(BigInteger, ForeignKey("game.game_id"))
    recommended_game_id = Column(BigInteger, ForeignKey("game.game_id"))
    similarity_score = Column(Float)
    recommend_rank = Column(Integer)
    created_at = Column(DateTime, default=datetime.now) 