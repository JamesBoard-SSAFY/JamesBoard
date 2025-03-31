import numpy as np
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
import models
from typing import List, Dict, Tuple, Optional
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
import pandas as pd
from scipy.sparse import csr_matrix
from sklearn.neighbors import NearestNeighbors

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class RecommendationEngine:
    def __init__(self, db: Session):
        self.db = db
        # 다국어 SBERT 모델
        self.model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")
        self.embeddings = None
        self._initialize_embeddings()
        self.n_clusters = 100
        self.batch_size = 1000
        self.reviews_df = None
        self.kmeans_model = None
        self.user_clusters = {}
        self._load_reviews_data()

    def _load_reviews_data(self):
        """리뷰 데이터를 CSV 파일에서 로드합니다."""
        try:
            self.reviews_df = pd.read_csv('filtered_reviews_korea_patch.csv')
            print(f"Loaded {len(self.reviews_df)} reviews from CSV")
        except Exception as e:
            print(f"Error loading reviews data: {str(e)}")
            self.reviews_df = None

    def _load_items_from_db(self) -> List[Dict]:
        """게임 데이터를 데이터베이스에서 로드합니다."""
        try:
            # 모든 게임 데이터 로드
            games = self.db.query(
                models.Game.game_id,
                models.Game.game_title,
                models.Game.game_description,
                models.Game.game_difficulty,
                models.Game.game_avg_rating,
                models.Game.game_review_count
            ).order_by(
                models.Game.game_id  # game_id 순으로 정렬하여 일관성 유지
            ).all()
            
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

            # 게임의 임베딩 가져오기 (game_id 1에 대한 특별 처리)
            try:
                game_idx = next(i for i, item in enumerate(self.items) if item['game_id'] == game_id)
            except StopIteration:
                print(f"Warning: game_id {game_id} not found in items list")
                return []

            # 배치 처리로 코사인 유사도 계산 (메모리 효율성 향상)
            batch_size = 100
            cosine_sim = np.zeros(len(self.embeddings))
            
            for i in range(0, len(self.embeddings), batch_size):
                batch_end = min(i + batch_size, len(self.embeddings))
                batch_sim = cosine_similarity(
                    self.embeddings[game_idx:game_idx+1],
                    self.embeddings[i:batch_end]
                )[0]
                cosine_sim[i:batch_end] = batch_sim
            
            # 자기 자신 제외하고 상위 N개 선택
            sim_scores = list(enumerate(cosine_sim))
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

            # game_id 1에 대한 추가 검증
            if game_id == 1 and not recommendations:
                print(f"Warning: No recommendations generated for game_id 1")
                return []

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
            
            # 저장 확인 (game_id 1인 경우 추가 검증)
            if game_id == 1:
                count = self.db.execute(
                    text(f"SELECT COUNT(*) FROM recommend_content WHERE game_id = {game_id}")
                ).scalar()
                print(f"Verified {count} recommendations saved for game_id: {game_id}")
                if count == 0:
                    print("Warning: No recommendations saved for game_id 1")
                    # 재시도 로직
                    self.db.rollback()
                    time.sleep(1)  # 잠시 대기
                    self.db.execute(text(delete_stmt))
                    self.db.execute(text(insert_stmt))
                    self.db.commit()
                    count = self.db.execute(
                        text(f"SELECT COUNT(*) FROM recommend_content WHERE game_id = {game_id}")
                    ).scalar()
                    print(f"After retry - Verified {count} recommendations saved for game_id: {game_id}")
            
        except Exception as e:
            print(f"Error saving recommendations for game_id {game_id}: {str(e)}")
            self.db.rollback()
            raise

    def get_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        """콘텐츠 기반 추천을 생성합니다."""
        try:
            # 게임 정보 조회
            game = self.db.query(models.Game).filter(models.Game.game_id == game_id).first()
            if not game:
                return []

            game_idx = next(i for i, item in enumerate(self.items) if item['game_id'] == game_id)
            
            batch_size = 100
            cosine_sim = np.zeros(len(self.embeddings))
            
            for i in range(0, len(self.embeddings), batch_size):
                batch_end = min(i + batch_size, len(self.embeddings))
                batch_sim = cosine_similarity(
                    self.embeddings[game_idx:game_idx+1],
                    self.embeddings[i:batch_end]
                )[0]
                cosine_sim[i:batch_end] = batch_sim
            
            # 자기 자신 제외하고 상위 N개 선택
            sim_scores = list(enumerate(cosine_sim))
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
                        "recommend_content_rank": len(recommendations) + 1,
                        "similarity_score": float(similarity)
                    })

            return recommendations
            
        except Exception as e:
            print(f"Error getting content recommendations: {str(e)}")
            return []

    def generate_user_clusters(self):
        """사용자 그룹화를 위한 K-means 클러스터링 수행"""
        try:
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
                vector = np.zeros(1000)
                for game_id, rating in ratings.items():
                    if game_id <= 1000:
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

    def get_collaborative_recommendations(
        self, 
        user_id: int, 
        user_activities: pd.DataFrame,
        top_n: int = 30
    ) -> List[Dict]:
        """협업 필터링 기반 추천을 생성합니다."""
        try:
            # 사용자의 클러스터 찾기
            user_cluster = self.get_user_cluster(user_id)
            if user_cluster is None:
                # 클러스터링이 실패한 경우, 모든 사용자의 리뷰를 사용
                cluster_reviews = self.reviews_df
            else:
                # 같은 클러스터의 사용자들의 리뷰 데이터 추출
                cluster_users = [uid for uid, cluster in self.user_clusters.items() if cluster == user_cluster]
                cluster_reviews = self.reviews_df[self.reviews_df['user'].isin(cluster_users)]
            
            if cluster_reviews.empty:
                return []
            
            # 게임별 평균 평점과 평가 수 계산
            game_ratings = cluster_reviews.groupby('ID').agg({
                'rating': ['mean', 'count']
            }).reset_index()
            
            # 컬럼명 변경
            game_ratings.columns = ['game_id', 'mean_rating', 'review_count']
            
            # 최소 1개 이상의 평가가 있는 게임만 선택 (조건 완화)
            game_ratings = game_ratings[game_ratings['review_count'] >= 1]
            
            # 상위 N개 게임 선택
            top_games = game_ratings.nlargest(top_n, 'mean_rating')
            
            # 추천 결과 생성
            recommendations = []
            for rank, (_, row) in enumerate(top_games.iterrows(), 1):
                recommendations.append({
                    'game_id': row['game_id'],
                    'score': row['mean_rating'],
                    'rank': rank
                })
            
            return recommendations

        except Exception as e:
            print(f"Error getting collaborative recommendations: {str(e)}")
            return []

    def save_hybrid_recommendations(self, recommendations: List[Dict]):
        """하이브리드 추천 결과를 데이터베이스에 저장합니다."""
        try:
            if not recommendations:
                return

            print(f"Saving {len(recommendations)} hybrid recommendations")
            
            # 기존 추천 결과 삭제
            user_id = recommendations[0]['user_id']
            
            # 트랜잭션 재시도를 위한 루프
            max_retries = 3
            for attempt in range(max_retries):
                try:
                    # 새로운 트랜잭션 시작
                    self.db.begin()
                    
                    # 기존 추천 결과 삭제
                    self.db.execute(
                        text("DELETE FROM recommend WHERE user_id = :user_id"),
                        {"user_id": user_id}
                    )
                    
                    # 새로운 추천 결과 저장
                    for rec in recommendations:
                        self.db.execute(
                            text("""
                                INSERT INTO recommend 
                                (user_id, game_id, recommend_rank, recommend_at) 
                                VALUES (:user_id, :game_id, :recommend_rank, NOW())
                            """),
                            {
                                "user_id": rec['user_id'],
                                "game_id": rec['game_id'],
                                "recommend_rank": rec['recommend_rank']
                            }
                        )
                    
                    # 트랜잭션 커밋
                    self.db.commit()
                    
                    # 저장 확인
                    count = self.db.execute(
                        text("SELECT COUNT(*) FROM recommend WHERE user_id = :user_id"),
                        {"user_id": user_id}
                    ).scalar()
                    print(f"Verified {count} recommendations saved for user_id: {user_id}")
                    
                    # 성공적으로 저장되면 루프 종료
                    break
                    
                except Exception as e:
                    print(f"Attempt {attempt + 1} failed: {str(e)}")
                    self.db.rollback()
                    
                    # 마지막 시도가 아니면 잠시 대기 후 재시도
                    if attempt < max_retries - 1:
                        time.sleep(1)
                    else:
                        raise
            
        except Exception as e:
            print(f"Error saving hybrid recommendations: {str(e)}")
            self.db.rollback()
            raise

    def generate_all_hybrid_recommendations(self):
        """모든 사용자에 대한 하이브리드 추천을 생성합니다."""
        try:
            print("Starting hybrid recommendations generation...")
            
            # 사용자 ID 목록 가져오기
            user_ids = self.db.query(models.UserActivity.user_id).distinct().all()
            if not user_ids:
                print("No users found in user_activity table")
                return {"message": "No users found"}
            
            print(f"Found {len(user_ids)} users")
            
            # 각 사용자별로 추천 생성
            for user_id in user_ids:
                try:
                    print(f"\nProcessing user_id: {user_id[0]}")
                    
                    # 사용자의 활동 데이터 가져오기
                    user_activities = self.get_user_activity_data(user_id[0])
                    if user_activities.empty:
                        print(f"No activities found for user {user_id[0]}")
                        continue
                    
                    # 사용자가 가장 선호하는 게임 찾기
                    favorite_game = user_activities.nlargest(1, 'rating').iloc[0]
                    favorite_game_id = favorite_game['game_id']
                    
                    # 협업 필터링 추천 (70%)
                    collaborative_recs = self.get_collaborative_recommendations(
                        user_id[0], 
                        user_activities,
                        30
                    )
                    
                    # 콘텐츠 기반 추천 (30%)
                    content_recs = self.get_content_recommendations(favorite_game_id, 30)
                    
                    # 추천 결과 통합 및 정규화
                    hybrid_scores = defaultdict(float)
                    
                    # 협업 필터링 점수 (70%)
                    for rec in collaborative_recs:
                        rank_score = 1.0 / rec['rank']
                        hybrid_scores[rec['game_id']] += rank_score * 0.7
                    
                    # 콘텐츠 기반 점수 (30%)
                    for rec in content_recs:
                        rank_score = 1.0 / rec['recommend_content_rank']
                        hybrid_scores[rec['recommend_game_id']] += rank_score * 0.3
                    
                    # 최종 순위 생성
                    final_rankings = sorted(
                        hybrid_scores.items(),
                        key=lambda x: x[1],
                        reverse=True
                    )[:30]
                    
                    # 추천 결과 저장
                    recommendations = [
                        {
                            'user_id': user_id[0],
                            'game_id': game_id,
                            'recommend_rank': rank
                        }
                        for rank, (game_id, _) in enumerate(final_rankings, 1)
                    ]
                    
                    self.save_hybrid_recommendations(recommendations)
                    print(f"Generated and saved recommendations for user {user_id[0]}")
                    
                except Exception as e:
                    print(f"Error processing user {user_id[0]}: {str(e)}")
                    continue
            
            print("\nHybrid recommendations generation completed")
            return {"message": "Successfully generated hybrid recommendations"}
            
        except Exception as e:
            print(f"Error in generate_all_hybrid_recommendations: {str(e)}")
            self.db.rollback()
            return {"message": f"Error generating recommendations: {str(e)}"}

    def get_user_activity_data(self, user_id: int) -> pd.DataFrame:
        """사용자의 활동 데이터를 가져옵니다."""
        try:
            user_activities = self.db.query(models.UserActivity).filter(
                models.UserActivity.user_id == user_id
            ).all()
            
            activities_data = []
            for activity in user_activities:
                activities_data.append({
                    'user_id': activity.user_id,
                    'game_id': activity.game_id,
                    'rating': activity.user_activity_rating,
                    'created_at': activity.created_at
                })
            
            return pd.DataFrame(activities_data)
        except Exception as e:
            print(f"Error getting user activity data: {str(e)}")
            return pd.DataFrame()

    def create_collaborative_matrix(self, user_activities: pd.DataFrame) -> Tuple[csr_matrix, Dict]:
        """협업 필터링을 위한 사용자-게임 매트릭스를 생성합니다."""
        try:
            # 사용자 활동 데이터와 리뷰 데이터 병합
            merged_data = pd.merge(
                user_activities,
                self.reviews_df,
                left_on='game_id',
                right_on='ID'
            )
            
            # 사용자-게임 매트릭스 생성
            user_game_matrix = merged_data.pivot(
                index='user',
                columns='ID',
                values='rating'
            ).fillna(0)
            
            # 매트릭스를 sparse matrix로 변환
            sparse_matrix = csr_matrix(user_game_matrix.values)
            
            # 게임 ID 매핑 생성
            game_mapping = {
                idx: game_id 
                for idx, game_id in enumerate(user_game_matrix.columns)
            }
            
            return sparse_matrix, game_mapping
            
        except Exception as e:
            print(f"Error creating collaborative matrix: {str(e)}")
            return None, None

    def get_user_cluster(self, user_id: int) -> Optional[int]:
        """사용자의 클러스터를 반환합니다."""
        try:
            if user_id in self.user_clusters:
                return self.user_clusters[user_id]
            
            # 사용자의 리뷰 데이터 가져오기
            user_reviews = self.reviews_df[self.reviews_df['user'] == user_id]
            if user_reviews.empty:
                return None
            
            # 사용자의 평균 평점 계산
            user_rating = user_reviews['rating'].mean()
            
            # 데이터 정규화
            scaler = StandardScaler()
            user_data = np.array([[user_rating]])
            user_data_scaled = scaler.fit_transform(user_data)
            
            # 클러스터 예측
            cluster = self.kmeans_model.predict(user_data_scaled)[0]
            self.user_clusters[user_id] = cluster
            
            return cluster
            
        except Exception as e:
            print(f"Error getting user cluster: {str(e)}")
            return None

    def _train_clustering_model(self) -> bool:
        """클러스터링 모델을 학습시킵니다."""
        try:
            if self.reviews_df is None or self.reviews_df.empty:
                print("No review data available for clustering")
                return False
            
            print("Starting clustering model training...")
            print(f"Total reviews: {len(self.reviews_df)}")
            
            # 사용자별 평균 평점과 평가 수 계산
            user_ratings = self.reviews_df.groupby('user').agg({
                'rating': ['mean', 'count']
            }).reset_index()
            
            # 컬럼명 변경
            user_ratings.columns = ['user', 'mean_rating', 'review_count']
            
            # 최소 1개 이상의 평가가 있는 사용자만 선택 (조건 완화)
            user_ratings = user_ratings[user_ratings['review_count'] >= 1]
            
            print(f"Users with reviews: {len(user_ratings)}")
            
            if len(user_ratings) < self.n_clusters:
                print(f"Not enough users for {self.n_clusters} clusters")
                return False
            
            # 데이터 정규화
            X = user_ratings[['mean_rating', 'review_count']].values
            scaler = StandardScaler()
            X_scaled = scaler.fit_transform(X)
            
            # MiniBatchKMeans 모델 학습
            self.kmeans_model = MiniBatchKMeans(
                n_clusters=self.n_clusters,
                batch_size=self.batch_size,
                random_state=42
            )
            self.kmeans_model.fit(X_scaled)
            
            # 사용자별 클러스터 할당
            for _, row in user_ratings.iterrows():
                user_data = row[['mean_rating', 'review_count']].values.reshape(1, -1)
                user_data_scaled = scaler.transform(user_data)
                cluster = self.kmeans_model.predict(user_data_scaled)[0]
                self.user_clusters[row['user']] = cluster
            
            print(f"Clustering model trained successfully with {len(user_ratings)} users")
            return True
            
        except Exception as e:
            print(f"Error training clustering model: {str(e)}")
            return False

    def get_hybrid_recommendations(self, user_id: int, top_n: int = 30) -> List[Dict]:
        """하이브리드 추천을 생성합니다."""
        try:
            # 사용자 활동 데이터 가져오기
            user_activities = self.get_user_activity_data(user_id)
            if user_activities.empty:
                return []

            # 사용자가 가장 선호하는 게임 찾기 (평점이 가장 높은 게임)
            favorite_game = user_activities.nlargest(1, 'rating').iloc[0]
            favorite_game_id = favorite_game['game_id']

            # 협업 필터링 추천 (70%)
            collaborative_recs = self.get_collaborative_recommendations(
                user_id, 
                user_activities,
                top_n
            )

            # 콘텐츠 기반 추천 (30%)
            content_recs = self.get_content_recommendations(favorite_game_id, top_n)

            # 추천 결과 통합 및 정규화
            hybrid_scores = defaultdict(float)
            
            # 협업 필터링 점수 (70%)
            for rec in collaborative_recs:
                rank_score = 1.0 / rec['rank']
                hybrid_scores[rec['game_id']] += rank_score * 0.7

            # 콘텐츠 기반 점수 (30%)
            for rec in content_recs:
                rank_score = 1.0 / rec['recommend_content_rank']
                hybrid_scores[rec['recommend_game_id']] += rank_score * 0.3

            # 최종 순위 생성
            final_rankings = sorted(
                hybrid_scores.items(),
                key=lambda x: x[1],
                reverse=True
            )[:top_n]

            # 추천 결과 생성
            recommendations = [
                {
                    'user_id': user_id,
                    'game_id': game_id,
                    'recommend_rank': rank
                }
                for rank, (game_id, _) in enumerate(final_rankings, 1)
            ]

            # 데이터베이스에 저장
            self.save_hybrid_recommendations(recommendations)
            
            return recommendations

        except Exception as e:
            print(f"Error getting hybrid recommendations: {str(e)}")
            return [] 