import numpy as np
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
import models
from typing import List, Dict, Tuple
from sentence_transformers import SentenceTransformer
import os
import time
from sqlalchemy import text
from sklearn.metrics.pairwise import cosine_similarity
import logging
from sqlalchemy.sql import func
from sklearn.cluster import MiniBatchKMeans
from collections import defaultdict
import faiss
from sklearn.preprocessing import StandardScaler
import gc

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class RecommendationEngine:
    def __init__(self, db: Session):
        self.db = db
        # 다국어 SBERT 모델 사용
        self.model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")
        self.embeddings = None  # 명시적으로 초기화
        self._initialize_embeddings()
        self.n_clusters = 10  # 클러스터 수 설정
        self.batch_size = 1000  # 미니 배치 크기

    def _load_items_from_db(self) -> List[Dict]:
        """게임 데이터를 데이터베이스에서 로드합니다."""
        try:
            # 상위 1000개의 게임 데이터 로드 (리뷰 수 기준)
            games = self.db.query(
                models.Game.game_id,
                models.Game.game_title,
                models.Game.game_description,
                models.Game.game_difficulty,
                models.Game.game_avg_rating,
                models.Game.game_review_count
            ).order_by(
                models.Game.game_review_count.desc()
            ).limit(1000).all()
            
            # 모든 게임 데이터를 리스트로 변환
            items = [{
                'game_id': game.game_id,
                'game_title': game.game_title,
                'game_description': game.game_description or '',  # None인 경우 빈 문자열로 처리
                'game_difficulty': game.game_difficulty,
                'game_avg_rating': game.game_avg_rating,
                'game_review_count': game.game_review_count
            } for game in games]
            
            print(f"Loaded {len(items)} games from database")
            return items
            
        except Exception as e:
            logger.error(f"게임 데이터 로드 중 오류: {str(e)}")
            return []

    def _initialize_embeddings(self):
        """임베딩 초기화 (저장된 임베딩 재사용)"""
        try:
            # 저장된 임베딩 파일 경로
            embedding_file = 'game_embeddings.npy'
            
            # 데이터베이스에서 게임 데이터 로드
            self.items = self._load_items_from_db()
            
            if os.path.exists(embedding_file):
                print("Loading existing embeddings...")
                # 저장된 임베딩 로드
                self.embeddings = np.load(embedding_file)
                return
            
            print("Computing new embeddings...")
            # 게임 설명만 사용
            sentences = [item.get('game_description', '') for item in self.items]
            
            if sentences:
                # 배치 처리로 임베딩 계산 (메모리 효율성 향상)
                batch_size = 32
                embeddings_list = []
                for i in range(0, len(sentences), batch_size):
                    batch = sentences[i:i + batch_size]
                    batch_embeddings = self.model.encode(batch)
                    embeddings_list.append(batch_embeddings)
                
                self.embeddings = np.vstack(embeddings_list)
                # 임베딩 저장
                np.save(embedding_file, self.embeddings)
                print("New embeddings computed and saved")
            else:
                print("No sentences found for embedding computation")
                self.embeddings = np.array([])
                
        except Exception as e:
            print(f"Error in embedding initialization: {e}")
            self.embeddings = None

    def calculate_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        """게임 ID에 대한 컨텐츠 기반 추천을 계산합니다."""
        try:
            # 게임 정보 조회
            game = self.db.query(models.Game).filter(models.Game.game_id == game_id).first()
            if not game:
                return []

            # 게임의 임베딩 가져오기
            game_idx = next(i for i, item in enumerate(self.items) if item['game_id'] == game_id)
            
            # 전체 임베딩 행렬의 코사인 유사도 계산
            cosine_sim = cosine_similarity(self.embeddings, self.embeddings)
            
            # 자기 자신 제외하고 상위 N개 선택
            sim_scores = list(enumerate(cosine_sim[game_idx]))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)[1:top_n+1]
            
            # 상세 정보 조회 (한 번의 쿼리로 모든 게임 정보 가져오기)
            similar_game_ids = [self.items[idx]['game_id'] for idx, _ in sim_scores]
            similar_games = {
                game.game_id: game 
                for game in self.db.query(models.Game)
                .filter(models.Game.game_id.in_(similar_game_ids))
                .all()
            }
            
            # 추천 결과 생성
            recommendations = []
            for idx, similarity in sim_scores:
                similar_game_id = self.items[idx]['game_id']
                if similar_game_id in similar_games:
                    recommendations.append({
                        "game_id": game_id,
                        "recommend_game_id": similar_game_id,
                        "recommend_content_rank": len(recommendations) + 1
                    })

            return recommendations

        except Exception as e:
            print(f"Error calculating content recommendations: {str(e)}")
            return []

    def save_recommendations(self, recommendations: List[Dict], game_id: int):
        try:
            print(f"Saving recommendations for game_id: {game_id}")
            print(f"Number of recommendations: {len(recommendations)}")
            
            # 기존 추천 결과 삭제
            delete_stmt = f"DELETE FROM recommend_content WHERE game_id = {game_id}"
            self.db.execute(text(delete_stmt))

            # 새로운 추천 결과 저장
            insert_values = []
            for rec in recommendations:
                insert_values.append(
                    f"({rec['game_id']}, {rec['recommend_game_id']}, {rec['recommend_content_rank']})"
                )
            
            if insert_values:
                insert_stmt = f"""
                    INSERT INTO recommend_content 
                    (game_id, recommend_game_id, recommend_content_rank) 
                    VALUES {','.join(insert_values)}
                """
                self.db.execute(text(insert_stmt))
            
            # 명시적으로 커밋
            self.db.commit()
            
            # 저장 확인
            count = self.db.execute(
                text(f"SELECT COUNT(*) FROM recommend_content WHERE game_id = {game_id}")
            ).scalar()
            print(f"Verified {count} recommendations saved for game_id: {game_id}")
            
        except Exception as e:
            print(f"Error saving recommendations for game_id {game_id}: {str(e)}")
            self.db.rollback()
            raise

    def get_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        """콘텐츠 기반 추천을 위한 메서드"""
        try:
            # 추천 결과 조회
            recommendations = (
                self.db.query(models.RecommendContent, models.Game)
                .join(models.Game, models.RecommendContent.recommend_game_id == models.Game.game_id)
                .filter(models.RecommendContent.game_id == game_id)
                .order_by(models.RecommendContent.recommend_content_rank)
            .limit(top_n)
            .all()
        )
        
            if recommendations:
                return [{
                    "game_id": rec.RecommendContent.game_id,
                    "recommend_game_id": rec.RecommendContent.recommend_game_id,
                    "recommend_content_rank": rec.RecommendContent.recommend_content_rank,
                    "game_title": rec.Game.game_title,
                    "game_description": rec.Game.game_description,
                    "game_image": rec.Game.game_image,
                    "game_year": rec.Game.game_year,
                    "game_difficulty": rec.Game.game_difficulty,
                    "game_avg_rating": rec.Game.game_avg_rating,
                    "game_review_count": rec.Game.game_review_count
                } for rec in recommendations]
        
            # 추천이 없는 경우 새로 계산
            new_recommendations = self.calculate_content_recommendations(game_id, top_n)
            self.save_recommendations(new_recommendations, game_id)
            
            # 저장된 추천 다시 조회
            recommendations = (
                self.db.query(models.RecommendContent, models.Game)
                .join(models.Game, models.RecommendContent.recommend_game_id == models.Game.game_id)
                .filter(models.RecommendContent.game_id == game_id)
                .order_by(models.RecommendContent.recommend_content_rank)
                .limit(top_n)
                .all()
            )
            
            return [{
                "game_id": rec.RecommendContent.game_id,
                "recommend_game_id": rec.RecommendContent.recommend_game_id,
                "recommend_content_rank": rec.RecommendContent.recommend_content_rank,
                "game_title": rec.Game.game_title,
                "game_description": rec.Game.game_description,
                "game_image": rec.Game.game_image,
                "game_year": rec.Game.game_year,
                "game_difficulty": rec.Game.game_difficulty,
                "game_avg_rating": rec.Game.game_avg_rating,
                "game_review_count": rec.Game.game_review_count
            } for rec in recommendations]
            
        except Exception as e:
            print(f"Error in get_content_recommendations: {str(e)}")
            return []

    def generate_user_clusters(self):
        """사용자 그룹화를 위한 K-means 클러스터링 수행"""
        try:
            print("Starting user clustering...")
            
            # 사용자-게임 매트릭스 생성
            user_activities = self.db.query(
                models.UserActivity.user_id,
                models.UserActivity.game_id,
                func.avg(models.UserActivity.user_activity_rating).label('avg_rating')
            ).group_by(
                models.UserActivity.user_id,
                models.UserActivity.game_id
            ).all()
            
            # 사용자별 게임 평점을 딕셔너리로 변환
            user_ratings = defaultdict(dict)
            for activity in user_activities:
                user_ratings[activity.user_id][activity.game_id] = float(activity.avg_rating)
            
            # 사용자 벡터 생성
            user_vectors = []
            user_ids = []
            for user_id, ratings in user_ratings.items():
                vector = np.zeros(1000)  # 상위 1000개 게임에 대해서만 고려
                for game_id, rating in ratings.items():
                    if game_id <= 1000:  # 상위 1000개 게임만 고려
                        vector[game_id - 1] = rating
                user_vectors.append(vector)
                user_ids.append(user_id)
            
            # MiniBatchKMeans 수행
            kmeans = MiniBatchKMeans(n_clusters=self.n_clusters, batch_size=self.batch_size)
            clusters = kmeans.fit_predict(user_vectors)
            
            # 클러스터 결과 저장
            cluster_results = defaultdict(list)
            for user_id, cluster_id in zip(user_ids, clusters):
                cluster_results[cluster_id].append(user_id)
            
            print(f"Clustering completed. Found {len(cluster_results)} clusters")
            return cluster_results
            
        except Exception as e:
            print(f"Error in user clustering: {str(e)}")
            return None

    def generate_collaborative_recommendations_for_cluster(self, cluster_users: List[int], top_n: int = 30):
        """클러스터별 협업 필터링 추천 생성 (FAISS + IVF 사용)"""
        try:
            print(f"Processing cluster with {len(cluster_users)} users using FAISS + IVF...")
            
            # 1. 전체 게임 수 조회
            total_games = self.db.query(func.count(models.Game.game_id)).scalar()
            print(f"Total number of games: {total_games}")
            
            # 2. 사용자 그룹화 (각 그룹당 1000명)
            GROUP_SIZE = 1000
            user_groups = [cluster_users[i:i + GROUP_SIZE] for i in range(0, len(cluster_users), GROUP_SIZE)]
            print(f"Created {len(user_groups)} user groups")
            
            # 3. 각 그룹별로 처리
            all_recommendations = {}
            for group_idx, group_users in enumerate(user_groups):
                print(f"Processing group {group_idx + 1}/{len(user_groups)} with {len(group_users)} users")
                
                # 그룹의 사용자-게임 매트릭스 생성
                matrix = np.zeros((len(group_users), total_games), dtype=np.float32)
                
                # 그룹의 사용자 활동 데이터 로드
                user_activities = self.db.query(
                    models.UserActivity.user_id,
                    models.UserActivity.game_id,
                    func.avg(models.UserActivity.user_activity_rating).label('avg_rating')
                ).filter(
                    models.UserActivity.user_id.in_(group_users)
                ).group_by(
                    models.UserActivity.user_id,
                    models.UserActivity.game_id
                ).all()
                
                # 매트릭스 구성
                for activity in user_activities:
                    user_idx = group_users.index(activity.user_id)
                    matrix[user_idx, activity.game_id - 1] = float(activity.avg_rating)
                
                # 4. IVF 인덱스 생성 및 최적화
                dimension = matrix.shape[1]
                nlist = min(50, len(group_users) // 5)  # 그룹 크기에 맞게 조정
                
                # IVF 인덱스 생성
                quantizer = faiss.IndexFlatL2(dimension)
                index = faiss.IndexIVFFlat(quantizer, dimension, nlist, faiss.METRIC_L2)
                
                # 정규화
                scaler = StandardScaler()
                matrix_normalized = scaler.fit_transform(matrix)
                
                # 인덱스 학습 및 데이터 추가
                index.train(matrix_normalized.astype('float32'))
                index.add(matrix_normalized.astype('float32'))
                
                # 5. 유사도 검색
                k = min(10, len(group_users))
                index.nprobe = 10
                D, I = index.search(matrix_normalized.astype('float32'), k)
                
                # 6. 추천 생성
                group_recommendations = {}
                for i, user_id in enumerate(group_users):
                    similar_users = [group_users[idx] for idx in I[i][1:]]
                    similar_scores = D[i][1:]
                    
                    # 가중 평균 계산
                    weights = 1.0 / (similar_scores + 1e-6)
                    game_scores = np.zeros(total_games, dtype=np.float32)
                    weight_sums = np.zeros(total_games, dtype=np.float32)
                    
                    for j, similar_user_id in enumerate(similar_users):
                        user_ratings = matrix[group_users.index(similar_user_id)]
                        game_scores += user_ratings * weights[j]
                        weight_sums += weights[j]
                    
                    # 최종 점수 계산
                    final_scores = np.divide(game_scores, weight_sums, where=weight_sums!=0)
                    top_indices = np.argsort(final_scores)[-top_n:][::-1]
                    
                    # 추천 결과 저장
                    group_recommendations[user_id] = []
                    for rank, game_idx in enumerate(top_indices, 1):
                        group_recommendations[user_id].append({
                            "user_id": user_id,
                            "game_id": game_idx + 1,
                            "recommend_rank": rank,
                            "score": float(final_scores[game_idx])
                        })
                
                # 그룹 결과 저장
                all_recommendations.update(group_recommendations)
                
                # 메모리 정리
                del matrix
                del matrix_normalized
                del index
                gc.collect()
                
                print(f"Completed processing group {group_idx + 1}")
            
            print(f"Completed FAISS + IVF based recommendations for cluster")
            return all_recommendations
            
        except Exception as e:
            print(f"Error in FAISS + IVF based collaborative filtering: {str(e)}")
            return None

    def update_hybrid_recommendations(self):
        """하이브리드 추천 업데이트 (협업 필터링 70% + 콘텐츠 기반 30%)"""
        try:
            print("Starting hybrid recommendations update...")
            
            # 1. 사용자 클러스터링
            cluster_results = self.generate_user_clusters()
            if not cluster_results:
                return
            
            # 2. 각 클러스터별 협업 필터링 추천 생성
            all_recommendations = {}
            for cluster_id, cluster_users in cluster_results.items():
                print(f"Processing cluster {cluster_id} with {len(cluster_users)} users")
                cluster_recommendations = self.generate_collaborative_recommendations_for_cluster(cluster_users)
                if cluster_recommendations:
                    all_recommendations.update(cluster_recommendations)
            
            # 3. 콘텐츠 기반 추천 가져오기
            content_recommendations = {}
            for user_id in all_recommendations.keys():
                user = self.db.query(models.User).filter(models.User.user_id == user_id).first()
                if user and user.prefer_game_id:
                    content_recs = self.get_content_recommendations(user.prefer_game_id)
                    if content_recs:
                        content_recommendations[user_id] = content_recs
            
            # 4. 하이브리드 점수 계산 및 업데이트
            for user_id, collab_recs in all_recommendations.items():
                if user_id in content_recommendations:
                    # 콘텐츠 기반 추천이 있는 경우 하이브리드 점수 계산
                    content_recs = content_recommendations[user_id]
                    hybrid_scores = {}
                    
                    # 협업 필터링 점수 (70%)
                    for rec in collab_recs:
                        hybrid_scores[rec['game_id']] = rec['score'] * 0.7
                    
                    # 콘텐츠 기반 점수 (30%)
                    for rec in content_recs:
                        game_id = rec['recommend_game_id']
                        score = 1.0 / rec['recommend_content_rank'] * 0.3
                        hybrid_scores[game_id] = hybrid_scores.get(game_id, 0) + score
                    
                    # 최종 순위 업데이트
                    final_rankings = sorted(hybrid_scores.items(), key=lambda x: x[1], reverse=True)
                    for rank, (game_id, score) in enumerate(final_rankings, 1):
                        self.db.query(models.Recommend).filter(
                            models.Recommend.user_id == user_id,
                            models.Recommend.game_id == game_id
                        ).update({
                            models.Recommend.recommend_rank: rank
                        })
                else:
                    # 콘텐츠 기반 추천이 없는 경우 협업 필터링 순위만 사용
                    for rec in collab_recs:
                        self.db.query(models.Recommend).filter(
                            models.Recommend.user_id == user_id,
                            models.Recommend.game_id == rec['game_id']
                        ).update({
                            models.Recommend.recommend_rank: rec['recommend_rank']
                        })
            
            self.db.commit()
            print("Hybrid recommendations update completed")
            
        except Exception as e:
            print(f"Error in update_hybrid_recommendations: {str(e)}")
            self.db.rollback()
            raise

    def generate_all_hybrid_recommendations(self):
        """모든 사용자에 대한 하이브리드 추천 생성"""
        try:
            print("Starting hybrid recommendations generation...")
            
            # 1. 기존 추천 결과 삭제
            self.db.execute(text("TRUNCATE TABLE recommend"))
            self.db.commit()
            
            # 2. 사용자 클러스터링 및 협업 필터링 추천 생성
            cluster_results = self.generate_user_clusters()
            if not cluster_results:
                return
            
            # 3. 각 클러스터별 협업 필터링 추천 생성 및 저장
            all_recommendations = []
            for cluster_id, cluster_users in cluster_results.items():
                print(f"Processing cluster {cluster_id} with {len(cluster_users)} users")
                cluster_recommendations = self.generate_collaborative_recommendations_for_cluster(cluster_users)
                if cluster_recommendations:
                    for user_recs in cluster_recommendations.values():
                        all_recommendations.extend(user_recs)
            
            # 4. 초기 추천 결과 저장
            if all_recommendations:
                self.db.bulk_insert_mappings(models.Recommend, all_recommendations)
                self.db.commit()
                print(f"Initial recommendations saved: {len(all_recommendations)}")
            
            # 5. 하이브리드 추천 업데이트
            self.update_hybrid_recommendations()
            
            # 6. 최종 결과 확인
            total_recommendations = self.db.query(func.count(models.Recommend.recommend_id)).scalar()
            print(f"Completed hybrid recommendations generation. Total recommendations: {total_recommendations}")
            return {"message": f"Successfully generated {total_recommendations} recommendations for all users"}
            
        except Exception as e:
            print(f"Error in generate_all_hybrid_recommendations: {str(e)}")
            self.db.rollback()
            raise 