from fastapi import FastAPI
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
# # from database import get_db
# # from models import Content
from recommendation import Recommendation

app = FastAPI()

# # APScheduler 스케줄러 초기화
# scheduler = BackgroundScheduler()

# # 새벽 3시마다 업데이트 하는 코드
# @app.on_event("startup")
# def start_scheduler():
#     scheduler.start()

# @app.on_event("shutdown")
# def shutdown_scheduler():
#     scheduler.shutdown()


@app.get("/")
def read_root():
    return {"message" : "fast API 작동된다"}


# 컨텐츠 기반 필터링 100개 반환
@app.get("/fastapi/contents")
@app.put("/fastapi/contents")
def run_contents_recommendation():
    return Recommendation.contents()


@app.put("/fastapi/hybrid")
def run_hybrid_recommendation():
    return Recommendation.hybrid()


# # 하이브리드 기반 필터링 100개 반환
# @app.put("/fastapi/hybrid")
# def run_hybrid_recommendation():
#     return Recommendation.hybrid()


# 새벽 3시에 실행
# scheduler.add_job(run_contents_recommendation, CronTrigger(hour=3, minute=0))
# scheduler.add_job(run_hybrid_recommendation, CronTrigger(hour=3, minute=0))