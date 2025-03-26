from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional, Dict
import pandas as pd
import models
import bigdata
from config import engine, get_db, test_mysql_connection, test_sqlalchemy_connection
from bigdata import RecommendationEngine
from pydantic import BaseModel
from datetime import datetime
import time
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from sqlalchemy.sql import text

# 전역 RecommendationEngine 인스턴스
recommendation_engine = None

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

def generate_recommendations_job():
    """스케줄된 추천 생성 작업"""
    try:
        if recommendation_engine is None:
            print("RecommendationEngine이 초기화되지 않았습니다.")
            return
            
        print("Starting scheduled recommendation generation...")
        success = recommendation_engine.generate_hybrid_recommendations()
        
        if success:
            print("Scheduled recommendation generation completed successfully")
        else:
            print("Scheduled recommendation generation failed")
            
    except Exception as e:
        print(f"Error in scheduled recommendation generation: {e}")

@app.on_event("startup")
async def startup_event():
    """서버 시작 시 RecommendationEngine 초기화"""
    global recommendation_engine
    try:
        # 데이터베이스 연결 테스트
        if not test_mysql_connection():
            raise Exception("MySQL 연결 실패")
        if not test_sqlalchemy_connection():
            raise Exception("SQLAlchemy 연결 실패")
        
        # RecommendationEngine 초기화
        db = next(get_db())
        recommendation_engine = RecommendationEngine(db)
        print("RecommendationEngine initialized successfully")
        
        # 스케줄러 설정
        scheduler = BackgroundScheduler()
        scheduler.add_job(
            generate_recommendations_job,
            CronTrigger(hour=3, minute=0),  # 매일 오전 3시에 실행
            id='generate_recommendations_job'
        )
        scheduler.start()
        print("Scheduler started successfully")
        
    except Exception as e:
        print(f"Error during startup: {e}")
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
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        recommendations = recommendation_engine.get_content_recommendations(game_id)
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
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        recommendations = recommendation_engine.get_hybrid_recommendations(game_id, user_id)
        if not recommendations:
            raise HTTPException(
                status_code=404,
                detail="추천 데이터가 없습니다. 새벽 3시에 생성되거나 수동으로 생성해주세요."
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
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        recommendations = recommendation_engine.get_recommendations_by_rank(game_id, start_rank, end_rank)
        return recommendations
    except Exception as e:
        print(f"Error in get_content_recommendations_by_rank: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/trigger-recommendations")
async def trigger_recommendations(db: Session = Depends(get_db)):
    """수동으로 추천 생성을 트리거합니다."""
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
        
        success = recommendation_engine.generate_hybrid_recommendations()
        
        if success:
            return {"message": "추천 생성이 완료되었습니다."}
        else:
            raise HTTPException(status_code=500, detail="추천 생성 중 오류가 발생했습니다.")
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/trigger-hybrid-recommendations/{user_id}")
def trigger_hybrid_recommendations(user_id: int, db: Session = Depends(get_db)):
    """
    특정 사용자에 대한 하이브리드 추천을 수동으로 생성합니다.
    """
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        # 기존 추천 데이터 삭제
        db.execute(text(f"DELETE FROM recommend WHERE user_id = {user_id}"))
        db.commit()
        
        success = recommendation_engine.generate_hybrid_recommendations()
        
        if success:
            return {"message": "하이브리드 추천 생성이 완료되었습니다."}
        else:
            raise HTTPException(status_code=500, detail="하이브리드 추천 생성 중 오류가 발생했습니다.")
            
    except Exception as e:
        print(f"Error in trigger_hybrid_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/initialize-clusters")
def initialize_clusters(n_clusters: int = 10, batch_size: int = 100, db: Session = Depends(get_db)):
    """
    클러스터링을 초기화합니다.
    """
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        success = recommendation_engine._initialize_clusters(n_clusters, batch_size)
        
        if success:
            return {"message": "클러스터링이 초기화되었습니다."}
        else:
            raise HTTPException(status_code=500, detail="클러스터링 초기화 중 오류가 발생했습니다.")
            
    except Exception as e:
        print(f"Error in initialize_clusters: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/cluster-stats")
def get_cluster_stats(db: Session = Depends(get_db)):
    """
    클러스터 통계를 반환합니다.
    """
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        stats = recommendation_engine.analyze_cluster_stats()
        
        if isinstance(stats, str):
            raise HTTPException(status_code=404, detail=stats)
            
        return stats
        
    except Exception as e:
        print(f"Error in get_cluster_stats: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/generate-all-hybrid-recommendations")
async def generate_all_hybrid_recommendations():
    try:
        success = recommendation_engine.generate_all_hybrid_recommendations()
        return {"message": "Successfully generated hybrid recommendations"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/generate-recommendations")
async def generate_recommendations():
    try:
        success = recommendation_engine.generate_all_hybrid_recommendations()
        return {"message": "Successfully generated recommendations"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/generate-recommendations-job")
async def generate_recommendations_job():
    try:
        success = recommendation_engine.generate_all_hybrid_recommendations()
        return {"message": "Successfully generated recommendations"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/generate-recommendations-scheduler")
async def generate_recommendations_scheduler():
    try:
        success = recommendation_engine.generate_all_hybrid_recommendations()
        return {"message": "Successfully generated recommendations"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recommendations/{user_id}")
def get_recommendations(user_id: int, limit: int = 30, db: Session = Depends(get_db)):
    """
    특정 사용자의 추천 목록을 반환합니다.
    """
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        recommendations = recommendation_engine.get_recommendations_for_user(user_id, limit)
        
        if not recommendations:
            raise HTTPException(
                status_code=404,
                detail="추천 데이터가 없습니다. 새벽 3시에 생성되거나 수동으로 생성해주세요."
            )
            
        return recommendations
        
    except Exception as e:
        print(f"Error in get_recommendations: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.put("/trigger-content-recommendations")
async def trigger_content_recommendations(db: Session = Depends(get_db)):
    """콘텐츠 기반 추천을 수동으로 생성합니다."""
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        start_time = time.time()
        print("Starting content-based recommendation generation...")
        
        # 기존 추천 데이터 삭제
        db.execute(text("TRUNCATE TABLE recommend_content"))
        db.commit()
        
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
                
                # 콘텐츠 기반 추천 생성
                recommendations = recommendation_engine.calculate_content_recommendations(source_game_id)
                
                if not recommendations:
                    print(f"No recommendations generated for game_id: {source_game_id}")
                    failed_games.append(source_game_id)
                    continue
                
                print(f"Generated {len(recommendations)} recommendations")
                
                # 추천 데이터 저장
                recommendation_engine.save_recommendations(recommendations, source_game_id)
                
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
        
        print("\n=== Content Recommendation Generation Summary ===")
        print(f"Total processing time: {processing_time:.2f} seconds")
        print(f"Successfully processed: {processed_games}/{total_games} games")
        print(f"Failed games: {len(failed_games)}")
        if failed_games:
            print("Failed game IDs:", failed_games)
        
        return {
            "status": "success",
            "message": "Content-based recommendations generated successfully",
            "processed_games": processed_games,
            "total_games": total_games,
            "failed_games": failed_games,
            "processing_time": processing_time
        }
            
    except Exception as e:
        print(f"Critical error in content recommendation generation: {str(e)}")
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Failed to generate content recommendations: {str(e)}"
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)