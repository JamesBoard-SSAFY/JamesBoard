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
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger

# 데이터베이스 테이블 생성
try:
    models.Base.metadata.create_all(bind=engine)
    print("Database tables created successfully")
except Exception as e:
    print(f"Error creating database tables: {str(e)}")
    raise

app = FastAPI(title="보드게임 추천 시스템 API")

# Pydantic 모델
class RecommendContentResponse(BaseModel):
    recommend_content_id: Optional[int] = None
    game_id: int
    recommend_game_id: int
    recommend_content_rank: int

    class Config:
        from_attributes = True

class RecommendResponse(BaseModel):
    recommend_id: Optional[int] = None
    recommend_at: Optional[datetime] = None
    recommend_rank: int
    game_id: int
    user_id: int

    class Config:
        from_attributes = True

# 전역 변수로 recommendation_engine 선언
recommendation_engine = None

def generate_recommendations_job(db: Session):
    """새벽 3시에 실행될 추천 생성 작업"""
    try:
        print("Starting SBERT-based recommendation generation job...")
        start_time = time.time()
        
        # RecommendationEngine 초기화 (SBERT 모델 로드)
        engine = RecommendationEngine(db)
        
        # 모든 게임 ID 가져오기
        games = db.query(models.Game.game_id).all()
        game_ids = [game.game_id for game in games]
        
        total_games = len(game_ids)
        processed_games = 0
        failed_games = []
        
        print(f"Found {total_games} games to process")
        
        for source_game_id in game_ids:
            try:
                print(f"\nProcessing game_id: {source_game_id} ({processed_games + 1}/{total_games})")
                
                # SBERT를 사용하여 유사한 게임 찾기
                recommendations = engine.calculate_content_recommendations(source_game_id)
                
                if not recommendations:
                    print(f"No recommendations generated for game_id: {source_game_id}")
                    failed_games.append(source_game_id)
                    continue
                
                print(f"Generated {len(recommendations)} recommendations")
                
                # 추천 데이터 저장
                engine.save_recommendations(recommendations, source_game_id)
                
                processed_games += 1
                if processed_games % 10 == 0:
                    print(f"\nProgress: {processed_games}/{total_games} games ({(processed_games/total_games)*100:.2f}%)")
                    db.commit()  # 중간 커밋
                
            except Exception as e:
                print(f"Error processing game_id {source_game_id}: {str(e)}")
                failed_games.append(source_game_id)
                continue
        
        # 최종 커밋
        db.commit()
        
        end_time = time.time()
        processing_time = end_time - start_time
        
        print("\n=== Recommendation Generation Summary ===")
        print(f"Total processing time: {processing_time:.2f} seconds")
        print(f"Successfully processed: {processed_games}/{total_games} games")
        print(f"Failed games: {len(failed_games)}")
        if failed_games:
            print("Failed game IDs:", failed_games)
        
        return {
            "status": "success",
            "processed_games": processed_games,
            "total_games": total_games,
            "failed_games": failed_games,
            "processing_time": processing_time
        }
        
    except Exception as e:
        print(f"Critical error in recommendation generation job: {str(e)}")
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Failed to generate recommendations: {str(e)}"
        )

@app.on_event("startup")
async def startup_event():
    try:
        print("Testing database connections...")
        # MySQL 연결 테스트
        if not test_mysql_connection():
            raise Exception("MySQL connection failed during startup")
        
        # SQLAlchemy 연결 테스트
        if not test_sqlalchemy_connection():
            raise Exception("SQLAlchemy connection failed during startup")
            
        print("Database connections successful")
            
        # 스케줄러 초기화 및 시작
        scheduler = BackgroundScheduler()
        db = next(get_db())
        
        # 매일 새벽 3시에 실행되도록 설정
        scheduler.add_job(
            generate_recommendations_job,
            trigger=CronTrigger(hour=3),
            args=[db],
            id='generate_recommendations',
            name='Generate SBERT-based game recommendations daily at 3 AM',
            replace_existing=True
        )
        
        scheduler.start()
        print("Scheduler started - SBERT-based recommendations will be generated at 3 AM daily")
        
    except Exception as e:
        print(f"Error during startup: {str(e)}")
        raise

@app.get("/")
def read_root():
    return {"message": "보드게임 추천 시스템 API"}

@app.get("/recommend/content/{game_id}", response_model=List[RecommendContentResponse])
def get_content_recommendations(game_id: int, db: Session = Depends(get_db)):
    """
    특정 게임에 대한 콘텐츠 기반 추천을 반환합니다.
    """
    try:
        engine = RecommendationEngine(db)
        recommendations = engine.get_content_recommendations(game_id)
        if not recommendations:
            raise HTTPException(
                status_code=404,
                detail="추천 데이터가 없습니다. 새벽 3시에 생성되거나 수동으로 생성해주세요."
            )
        return recommendations
    except Exception as e:
        print(f"Error in get_content_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recommend/hybrid/{game_id}", response_model=List[RecommendResponse])
def get_hybrid_recommendations(game_id: int, user_id: int, db: Session = Depends(get_db)):
    """
    특정 게임에 대한 하이브리드 추천을 반환합니다.
    """
    try:
        engine = RecommendationEngine(db)
        recommendations = engine.get_hybrid_recommendations(game_id, user_id)
        if not recommendations:
            raise HTTPException(
                status_code=404,
                detail="하이브리드 추천 데이터가 아직 구현되지 않았습니다."
            )
        return recommendations
    except Exception as e:
        print(f"Error in get_hybrid_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recommend/content/{game_id}/rank", response_model=List[RecommendContentResponse])
def get_content_recommendations_by_rank(
    game_id: int,
    start_rank: int = 1,
    end_rank: int = 30,
    db: Session = Depends(get_db)
):
    """
    특정 게임에 대한 콘텐츠 기반 추천을 지정된 순위 범위로 반환합니다.
    """
    try:
        engine = RecommendationEngine(db)
        recommendations = engine.get_recommendations_by_rank(game_id, start_rank, end_rank)
        return recommendations
    except Exception as e:
        print(f"Error in get_content_recommendations_by_rank: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/trigger-recommendations")
def trigger_recommendations(db: Session = Depends(get_db)):
    """
    수동으로 SBERT 기반 추천 생성 작업을 트리거합니다.
    """
    try:
        generate_recommendations_job(db)
        return {"message": "SBERT-based recommendation generation triggered successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)