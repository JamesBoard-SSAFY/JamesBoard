from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from config import get_db, test_mysql_connection, test_sqlalchemy_connection
from bigdata import RecommendationEngine
from datetime import datetime
import time
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from sqlalchemy.sql import text
import models
import logging

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

recommendation_engine = None
scheduler = None

app = FastAPI(
    title="Recommend API",
    root_path="/recommends"
)

def setup_scheduler():
    """스케줄러 설정 및 작업 등록"""
    global scheduler
    scheduler = BackgroundScheduler()
    
    # # 콘텐츠 기반 추천 (3:00 AM)
    # scheduler.add_job(
    #     generate_content_recommendations_job,
    #     CronTrigger(hour=3, minute=0),
    #     id='generate_content_recommendations_job'
    # )
    
    # 하이브리드 추천 (3:30 AM)
    scheduler.add_job(
        generate_hybrid_recommendations_job,
        CronTrigger(minute="*/3"),
        id='generate_hybrid_recommendations_job'
    )
    
    scheduler.start()
    logger.info("Scheduler started successfully")

def generate_content_recommendations_job():
    """스케줄된 콘텐츠 기반 추천 생성 작업"""
    try:
        if recommendation_engine is None:
            logger.error("RecommendationEngine이 초기화되지 않았습니다.")
            return
            
        logger.info("Starting scheduled content-based recommendation generation...")
        db = next(get_db())
        
        # 기존 추천 데이터 삭제
        db.execute(text("TRUNCATE TABLE recommend_content"))
        db.commit()
        
        # 모든 게임 ID 가져오기
        games = db.query(models.Game.game_id).all()
        game_ids = [game.game_id for game in games]
        
        total_games = len(game_ids)
        processed_games = 0
        failed_games = []
        
        logger.info(f"Found {total_games} games to process")
        
        for source_game_id in game_ids:
            try:
                logger.info(f"Processing game_id: {source_game_id} ({processed_games + 1}/{total_games})")
                
                # 콘텐츠 기반 추천 생성
                recommendations = recommendation_engine.calculate_content_recommendations(source_game_id)
                
                if not recommendations:
                    logger.warning(f"No recommendations generated for game_id: {source_game_id}")
                    failed_games.append(source_game_id)
                    continue
                
                logger.info(f"Generated {len(recommendations)} recommendations")
                
                # 추천 데이터 저장
                recommendation_engine.save_recommendations(recommendations, source_game_id)
                
                processed_games += 1
                if processed_games % 10 == 0:
                    logger.info(f"Progress: {processed_games}/{total_games} games ({(processed_games/total_games)*100:.2f}%)")
                    db.commit()  # 중간 커밋
                
            except Exception as e:
                logger.error(f"Error processing game_id {source_game_id}: {str(e)}")
                failed_games.append(source_game_id)
                continue
        
        # 최종 커밋
        db.commit()
        logger.info("Content-based recommendation generation completed")
            
    except Exception as e:
        logger.error(f"Error in scheduled content-based recommendation generation: {e}")

def generate_hybrid_recommendations_job():
    """스케줄된 하이브리드 추천 생성 작업"""
    try:
        if recommendation_engine is None:
            logger.error("RecommendationEngine이 초기화되지 않았습니다.")
            return
            
        logger.info("Starting scheduled hybrid recommendation generation...")
        success = recommendation_engine.generate_all_hybrid_recommendations()
        
        if success:
            logger.info("Scheduled hybrid recommendation generation completed successfully")
        else:
            logger.error("Scheduled hybrid recommendation generation failed")
            
    except Exception as e:
        logger.error(f"Error in scheduled hybrid recommendation generation: {e}")

@app.on_event("startup")
async def startup_event():
    """서버 시작 시 RecommendationEngine 초기화 및 스케줄러 설정"""
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
        logger.info("RecommendationEngine initialized successfully")
        
        # 스케줄러 설정
        setup_scheduler()
        
    except Exception as e:
        logger.error(f"Error during startup: {e}")
        raise

@app.get("/", include_in_schema=False)
def read_root():
    return {"message": "보드게임 추천 시스템 API"}

@app.put("/fastapi/content-recommendations")
async def trigger_content_recommendations(db: Session = Depends(get_db)):
    """모든 사용자에 대한 콘텐츠 기반 추천을 생성(기존 테이블 초기화 동시 진행)"""
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        start_time = time.time()
        logger.info("Starting content-based recommendation generation...")
        
        # 기존 추천 데이터 삭제
        db.execute(text("TRUNCATE TABLE recommend_content"))
        db.commit()
        
        # 모든 게임 ID 가져오기
        games = db.query(models.Game.game_id).all()
        game_ids = [game.game_id for game in games]
        
        total_games = len(game_ids)
        processed_games = 0
        failed_games = []
        
        logger.info(f"Found {total_games} games to process")
        
        for source_game_id in game_ids:
            try:
                logger.info(f"Processing game_id: {source_game_id} ({processed_games + 1}/{total_games})")
                
                # 콘텐츠 기반 추천 생성
                recommendations = recommendation_engine.calculate_content_recommendations(source_game_id)
                
                if not recommendations:
                    logger.warning(f"No recommendations generated for game_id: {source_game_id}")
                    failed_games.append(source_game_id)
                    continue
                
                logger.info(f"Generated {len(recommendations)} recommendations")
                
                # 추천 데이터 저장
                recommendation_engine.save_recommendations(recommendations, source_game_id)
                
                processed_games += 1
                if processed_games % 10 == 0:
                    logger.info(f"Progress: {processed_games}/{total_games} games ({(processed_games/total_games)*100:.2f}%)")
                    db.commit()  # 중간 커밋
                
            except Exception as e:
                logger.error(f"Error processing game_id {source_game_id}: {str(e)}")
                failed_games.append(source_game_id)
                continue
        
        # 최종 커밋
        db.commit()
        
        end_time = time.time()
        processing_time = end_time - start_time
        
        logger.info("\n=== Content Recommendation Generation Summary ===")
        logger.info(f"Total processing time: {processing_time:.2f} seconds")
        logger.info(f"Successfully processed: {processed_games}/{total_games} games")
        logger.info(f"Failed games: {len(failed_games)}")
        if failed_games:
            logger.info("Failed game IDs:", failed_games)
        
        return {
            "status": "success",
            "message": "Content-based recommendations generated successfully",
            "processed_games": processed_games,
            "total_games": total_games,
            "failed_games": failed_games,
            "processing_time": processing_time
        }
            
    except Exception as e:
        logger.error(f"Critical error in content recommendation generation: {str(e)}")
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Failed to generate content recommendations: {str(e)}"
        )

@app.put("/fastapi/hybrid-recommendations")
async def generate_all_hybrid_recommendations(db: Session = Depends(get_db)):
    """모든 사용자에 대한 하이브리드 추천을 생성(기존 테이블 초기화 동시 진행)"""
    try:
        if recommendation_engine is None:
            raise HTTPException(status_code=500, detail="RecommendationEngine이 초기화되지 않았습니다.")
            
        start_time = time.time()
        logger.info("Starting hybrid recommendation generation...")
        
        # 기존 추천 데이터 삭제
        db.execute(text("TRUNCATE TABLE recommend"))
        db.commit()
        
        result = recommendation_engine.generate_all_hybrid_recommendations()
        
        if "message" in result and "Error" in result["message"]:
            raise HTTPException(status_code=500, detail=result["message"])
            
        end_time = time.time()
        processing_time = end_time - start_time
        
        logger.info(f"Hybrid recommendation generation completed in {processing_time:.2f} seconds")
        return {
            "status": "success",
            "message": "Successfully generated hybrid recommendations",
            "processing_time": processing_time
        }
        
    except Exception as e:
        logger.error(f"Critical error in hybrid recommendation generation: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)