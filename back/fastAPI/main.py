from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import pandas as pd
import models
from config import engine, get_db
from bigdata import RecommendationEngine, GameRecommender

# 데이터베이스 테이블 생성
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="보드게임 추천 시스템 API")

# 추천 엔진 초기화
recommender = GameRecommender()

@app.on_event("startup")
async def startup_event():
    # CSV에서 게임 데이터 로드
    games_df = pd.read_csv("games.csv")
    ratings_df = pd.read_csv("filtered_reviews.csv")
    recommender.load_data(games_df, ratings_df)

@app.get("/")
def read_root():
    return {"message": "보드게임 추천 시스템 API"}

@app.get("/items/{item_id}/content-recommendations")
def get_content_recommendations(
    item_id: int,
    top_n: int = 10,
    db: Session = Depends(get_db)
):
    engine = RecommendationEngine(db)
    return engine.get_content_recommendations(item_id, top_n)

@app.get("/games/{game_id}/recommendations/")
def get_game_recommendations(
    game_id: int,
    user_id: str = None,
    top_k: int = 5,
    db: Session = Depends(get_db)
):
    try:
        recommendations = recommender.get_recommendations(db, game_id, user_id, top_k)
        return {
            "recommendations": recommendations,
            "recommendation_type": "hybrid" if user_id and len(recommender.ratings_data[recommender.ratings_data["user"] == user_id]) >= 30 else "content-based"
        }
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 