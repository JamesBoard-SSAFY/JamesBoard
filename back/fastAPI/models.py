from sqlalchemy import Column, Integer, Float, DateTime
from config import Base

class ContentRecommendation(Base):
    __tablename__ = "content_recommendations"

    id = Column(Integer, primary_key=True, index=True)
    source_item_id = Column(Integer)  # 기준이 되는 아이템 ID
    target_item_id = Column(Integer)  # 추천되는 아이템 ID
    similarity_score = Column(Float)  # 유사도 점수
    game_rank = Column(Integer)  # 추천 순위
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    def __repr__(self):
        return f"<ContentRecommendation {self.source_item_id}->{self.target_item_id}: {self.similarity_score}>" 