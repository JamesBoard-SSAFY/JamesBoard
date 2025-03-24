from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional, Dict
import pandas as pd
import models
from config import engine, get_db, test_mysql_connection, test_sqlalchemy_connection
from bigdata import RecommendationEngine
from pydantic import BaseModel
from datetime import datetime
import time

# 데이터베이스 테이블 생성
try:
    models.Base.metadata.create_all(bind=engine)
    print("Database tables created successfully")
except Exception as e:
    print(f"Error creating database tables: {str(e)}")
    raise

app = FastAPI(title="보드게임 추천 시스템 API")

# Pydantic 모델
class RecommendResponse(BaseModel):
    game_id: int
    game_title: str
    recommend_rank: int
    recommend_at: Optional[datetime] = None
    

# 추천 엔진 초기화
recommendation_engine = None

@app.on_event("startup")
async def startup_event():
    global recommendation_engine
    try:
        # MySQL 연결 테스트
        if not test_mysql_connection():
            raise Exception("MySQL connection failed during startup")
        
        # SQLAlchemy 연결 테스트
        if not test_sqlalchemy_connection():
            raise Exception("SQLAlchemy connection failed during startup")
        
        # 추천 엔진 초기화
        db = next(get_db())
        recommendation_engine = RecommendationEngine(db)
        print("Recommendation engine initialized successfully")
    except Exception as e:
        print(f"Error during startup: {str(e)}")
        raise

@app.get("/")
def read_root():
    return {"message": "보드게임 추천 시스템 API"}

@app.get("/recommend/{game_id}", response_model=List[RecommendResponse])
def get_recommendations(game_id: int, db: Session = Depends(get_db)):
    """
    특정 게임에 대한 유사 게임 추천을 1~100순위까지 반환합니다.
    """
    try:
        if not recommendation_engine:
            raise HTTPException(status_code=500, detail="Recommendation engine not initialized")
        
        recommendations = recommendation_engine.get_content_recommendations(game_id)
        return recommendations
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        print(f"Error in get_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recommend/{game_id}/rank", response_model=List[RecommendResponse])
def get_recommendations_by_rank(
    game_id: int,
    start_rank: int = 1,
    end_rank: int = 100,
    db: Session = Depends(get_db)
):
    """
    특정 게임에 대한 유사 게임 추천을 지정된 순위 범위로 반환합니다.
    """
    try:
        if not recommendation_engine:
            raise HTTPException(status_code=500, detail="Recommendation engine not initialized")
        
        recommendations = recommendation_engine.get_recommendations_by_rank(
            game_id, start_rank, end_rank
        )
        return recommendations
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        print(f"Error in get_recommendations_by_rank: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recommend/category/{category}", response_model=List[RecommendResponse])
def get_category_recommendations(category: str, db: Session = Depends(get_db)):
    """
    특정 카테고리의 게임 추천을 반환합니다.
    """
    try:
        if not recommendation_engine:
            raise HTTPException(status_code=500, detail="Recommendation engine not initialized")
        
        recommendations = recommendation_engine.get_category_recommendations(category)
        return recommendations
    except Exception as e:
        print(f"Error in get_category_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate-all-recommendations")
def generate_all_recommendations(db: Session = Depends(get_db)):
    start_time = time.time()
    engine = RecommendationEngine(db)
    
    # 모든 게임 ID 가져오기
    games = db.query(models.Game.game_id).all()
    game_ids = [game.game_id for game in games]
    
    total_games = len(game_ids)
    processed_games = 0
    
    for game_id in game_ids:
        try:
            # 각 게임에 대한 추천 생성 및 저장
            recommendations = engine.calculate_content_recommendations(game_id)
            engine.save_recommendations(recommendations, game_id)
            processed_games += 1
            
            # 진행 상황 출력
            if processed_games % 10 == 0:
                print(f"Processed {processed_games}/{total_games} games")
                
        except Exception as e:
            print(f"Error processing game_id {game_id}: {str(e)}")
            continue
    
    end_time = time.time()
    total_time = end_time - start_time
    
    return {
        "message": f"Successfully generated recommendations for {processed_games}/{total_games} games",
        "total_time": f"{total_time:.2f} seconds",
        "average_time_per_game": f"{total_time/processed_games:.2f} seconds"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)