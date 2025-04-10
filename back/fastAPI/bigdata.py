import numpy as np
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
import models
from typing import List, Dict, Tuple, Optional
from sentence_transformers import SentenceTransformer
import os
import time
from sqlalchemy import text, func
from sklearn.metrics.pairwise import cosine_similarity
import logging
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
        self.model = SentenceTransformer("paraphrase-multilingual-MiniLM-L12-v2")
        self.embeddings = None
        self.n_clusters = 1000
        self.batch_size = 1000
        self.reviews_df = None
        self.kmeans_model = None
        self.user_clusters = {}
        
        # 초기화
        self._initialize_embeddings()
        self._load_reviews_data()
        self._train_clustering_model()

    def _load_reviews_data(self):
        """리뷰 데이터를 DB에서 로드하여 DataFrame으로 저장합니다."""
        try:
            activities = self.db.query(
                models.UserActivity.user_id,
                models.UserActivity.game_id,
                models.UserActivity.user_activity_rating.label("rating")
            ).all()

            self.reviews_df = pd.DataFrame([
                {
                    'user': str(a.user_id),
                    'ID': a.game_id,
                    'rating': float(a.rating)
                } for a in activities
            ])
            logger.info(f"Loaded {len(self.reviews_df)} reviews from DB")
        except Exception as e:
            logger.error(f"Error loading reviews data from DB: {str(e)}")
            self.reviews_df = pd.DataFrame()


    def _load_items_from_db(self) -> List[Dict]:
        """데이터베이스에서 게임 데이터 로드"""
        try:
            games = self.db.query(
                models.Game.game_id,
                models.Game.game_title,
                models.Game.game_description,
                models.Game.game_difficulty,
                models.Game.game_avg_rating,
                models.Game.game_review_count
            ).order_by(
                models.Game.game_id
            ).all()
            
            items = [{
                'game_id': game.game_id,
                'game_title': game.game_title,
                'game_description': game.game_description or '',
                'game_difficulty': game.game_difficulty,
                'game_avg_rating': game.game_avg_rating,
                'game_review_count': game.game_review_count
            } for game in games]
            
            logger.info(f"Loaded {len(items)} games from database")
            return items
            
        except Exception as e:
            logger.error(f"게임 데이터 로드 중 오류: {str(e)}")
            return []

    def _initialize_embeddings(self):
        """게임 설명에 대한 임베딩 초기화"""
        try:
            embedding_file = 'game_embeddings.npy'
            self.items = self._load_items_from_db()
            
            if os.path.exists(embedding_file):
                self.embeddings = np.load(embedding_file)
                return
            
            sentences = [item.get('game_description', '') for item in self.items]
            
            if sentences:
                batch_size = 32
                embeddings_list = []
                for i in range(0, len(sentences), batch_size):
                    batch = sentences[i:i + batch_size]
                    batch_embeddings = self.model.encode(batch)
                    embeddings_list.append(batch_embeddings)
                
                self.embeddings = np.vstack(embeddings_list)
                np.save(embedding_file, self.embeddings)
            else:
                self.embeddings = np.array([])
                
        except Exception as e:
            logger.error(f"Error initializing embeddings: {str(e)}")
            self.embeddings = None

    def calculate_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        """콘텐츠 기반 추천 생성"""
        try:
            game = self.db.query(models.Game).filter(models.Game.game_id == game_id).first()
            if not game:
                return []

            game_idx = next(i for i, item in enumerate(self.items) if item['game_id'] == game_id)
            
            cosine_sim = np.zeros(len(self.embeddings))
            batch_size = 100
            for i in range(0, len(self.embeddings), batch_size):
                batch_end = min(i + batch_size, len(self.embeddings))
                batch_sim = cosine_similarity(
                    self.embeddings[game_idx:game_idx+1],
                    self.embeddings[i:batch_end]
                )[0]
                cosine_sim[i:batch_end] = batch_sim
            
            sim_scores = sorted(enumerate(cosine_sim), key=lambda x: x[1], reverse=True)[1:top_n+1]
            similar_game_ids = [self.items[idx]['game_id'] for idx, _ in sim_scores]
            
            recommendations = []
            for idx, similarity in sim_scores:
                similar_game_id = self.items[idx]['game_id']
                recommendations.append({
                    "game_id": game_id,
                    "recommend_game_id": similar_game_id,
                    "recommend_content_rank": len(recommendations) + 1
                })

            return recommendations

        except Exception as e:
            logger.error(f"Error calculating content recommendations: {str(e)}")
            return []

    def save_recommendations(self, recommendations: List[Dict], game_id: int):
        """추천 데이터 저장"""
        try:
            self.db.execute(text(f"DELETE FROM recommend_content WHERE game_id = {game_id}"))

            if recommendations:
                insert_values = [
                    f"({rec['game_id']}, {rec['recommend_game_id']}, {rec['recommend_content_rank']})"
                    for rec in recommendations
                ]
                self.db.execute(text(f"""
                    INSERT INTO recommend_content 
                    (game_id, recommend_game_id, recommend_content_rank) 
                    VALUES {','.join(insert_values)}
                """))
            
            self.db.commit()
            
        except Exception as e:
            self.db.rollback()
            logger.error(f"Error saving recommendations: {str(e)}")
            raise

    def get_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        """게임에 대한 콘텐츠 기반 추천 조회"""
        try:
            game = self.db.query(models.Game).filter(models.Game.game_id == game_id).first()
            if not game:
                return []

            game_idx = next(i for i, item in enumerate(self.items) if item['game_id'] == game_id)
            
            cosine_sim = np.zeros(len(self.embeddings))
            batch_size = 100
            for i in range(0, len(self.embeddings), batch_size):
                batch_end = min(i + batch_size, len(self.embeddings))
                batch_sim = cosine_similarity(
                    self.embeddings[game_idx:game_idx+1],
                    self.embeddings[i:batch_end]
                )[0]
                cosine_sim[i:batch_end] = batch_sim
            
            sim_scores = sorted(enumerate(cosine_sim), key=lambda x: x[1], reverse=True)[1:top_n+1]
            
            recommendations = []
            for idx, similarity in sim_scores:
                similar_game_id = self.items[idx]['game_id']
                recommendations.append({
                    "game_id": game_id,
                    "recommend_game_id": similar_game_id,
                    "recommend_content_rank": len(recommendations) + 1,
                    "similarity_score": float(similarity)
                })

            return recommendations
            
        except Exception as e:
            logger.error(f"Error getting content recommendations: {str(e)}")
            return []

    def _train_clustering_model(self) -> bool:
        """사용자 클러스터링 모델 학습"""
        try:
            user_activities = self.db.query(
                models.UserActivity.user_id,
                func.avg(models.UserActivity.user_activity_rating).label('mean_rating'),
                func.count(models.UserActivity.game_id).label('review_count')
            ).group_by(
                models.UserActivity.user_id
            ).all()

            if not user_activities:
                logger.warning("No user activities found")
                return False

            user_ratings = pd.DataFrame([{
                'user': activity.user_id,
                'mean_rating': float(activity.mean_rating),
                'review_count': activity.review_count
            } for activity in user_activities])

            scaler = StandardScaler()
            features = ['mean_rating', 'review_count']
            user_data_scaled = scaler.fit_transform(user_ratings[features])

            self.kmeans_model = MiniBatchKMeans(
                n_clusters=self.n_clusters,
                batch_size=self.batch_size,
                random_state=42
            )
            self.kmeans_model.fit(user_data_scaled)

            self.user_clusters.clear()  # 🔥 기존 캐시 초기화

            for _, row in user_ratings.iterrows():
                user_data = row[features].values.reshape(1, -1)
                scaled = scaler.transform(user_data)
                cluster = self.kmeans_model.predict(scaled)[0]
                self.user_clusters[row['user']] = cluster

            logger.info(f"Clustering model trained successfully with {len(user_ratings)} users")
            return True

        except Exception as e:
            logger.error(f"Error training clustering model: {str(e)}")
            return False


    def get_user_cluster(self, user_id: int, force: bool = False) -> Optional[int]:
        """사용자의 클러스터 ID를 반환하며, force=True 시 재계산합니다."""
        try:
            if not force and user_id in self.user_clusters:
                return self.user_clusters[user_id]

            user_reviews = self.reviews_df[self.reviews_df['user'] == str(user_id)]
            if user_reviews.empty:
                return None

            mean_rating = user_reviews['rating'].mean()
            review_count = user_reviews.shape[0]

            X = np.array([[mean_rating, review_count]])
            scaler = StandardScaler()
            X_scaled = scaler.fit_transform(X)

            cluster = self.kmeans_model.predict(X_scaled)[0]
            self.user_clusters[user_id] = cluster
            return cluster

        except Exception as e:
            logger.error(f"Error getting user cluster: {str(e)}")
            return None


    def get_user_activity_data(self, user_id: int) -> pd.DataFrame:
        """사용자 활동 데이터 조회"""
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
            logger.error(f"Error getting user activity data: {str(e)}")
            return pd.DataFrame()


    def get_collaborative_recommendations(
        self, 
        user_id: int, 
        user_activities: pd.DataFrame,
        top_n: int = 30
    ) -> List[Dict]:
        """협업 필터링 기반 추천 생성"""
        try:
            user_cluster = self.get_user_cluster(user_id)
            if user_cluster is None:
                return []

            user_activities['user'] = user_activities['user_id'].astype(str)
            user_activities['rating'] = user_activities['user_activity_rating']
            user_activities['ID'] = user_activities['game_id']
            
            merged_data = pd.concat([
                self.reviews_df,
                user_activities[['user', 'rating', 'ID']]
            ], ignore_index=True)
            
            merged_data = merged_data.drop_duplicates(subset=['user', 'ID'], keep='last')
            user_rated_games = set(user_activities['game_id'].unique())
            
            cluster_users = [uid for uid, cluster in self.user_clusters.items() if cluster == user_cluster]
            cluster_reviews = merged_data[merged_data['user'].isin(cluster_users)]
            
            if cluster_reviews.empty:
                return []
            
            game_ratings = cluster_reviews.groupby('ID').agg({
                'rating': ['mean', 'count']
            }).reset_index()
            
            game_ratings.columns = ['game_id', 'mean_rating', 'review_count']
            game_ratings = game_ratings[~game_ratings['game_id'].isin(user_rated_games)]
            game_ratings = game_ratings[game_ratings['review_count'] >= 1]
            
            top_games = game_ratings.nlargest(top_n, 'mean_rating')
            
            recommendations = []
            for rank, (_, row) in enumerate(top_games.iterrows(), 1):
                recommendations.append({
                    'game_id': row['game_id'],
                    'score': row['mean_rating'],
                    'rank': rank
                })
            
            return recommendations

        except Exception as e:
            logger.error(f"Error getting collaborative recommendations: {str(e)}")
            return []

    def save_hybrid_recommendations(self, recommendations: List[Dict]):
        """하이브리드 추천 데이터 저장"""
        if not recommendations:
            return

        user_id = recommendations[0]['user_id']
        
        for attempt in range(3):
            try:
                self.db.begin()
                
                self.db.execute(
                    text("DELETE FROM recommend WHERE user_id = :user_id"),
                    {"user_id": user_id}
                )
                
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
                
                self.db.commit()
                break
                
            except Exception as e:
                self.db.rollback()
                if attempt == 2:
                    raise
                time.sleep(1)

    def generate_all_hybrid_recommendations(self):
        """모든 사용자에 대한 하이브리드 추천 생성"""
        try:
            # 🔄 최신화 처리
            self._load_reviews_data()
            self._train_clustering_model()

            user_ids = self.db.query(models.UserActivity.user_id).distinct().all()
            if not user_ids:
                return {"message": "No users found"}

            for user_id in user_ids:
                try:
                    user_activities = self.get_user_activity_data(user_id[0])
                    if user_activities.empty:
                        continue

                    # 사용자가 이미 평가한 게임 ID 목록
                    rated_game_ids = set(user_activities['game_id'].unique())

                    favorite_game = user_activities.nlargest(1, 'rating').iloc[0]
                    favorite_game_id = favorite_game['game_id']

                    collaborative_recs = self.get_collaborative_recommendations(
                        user_id[0], user_activities, 30
                    )

                    content_recs = self.get_content_recommendations(favorite_game_id, 30)

                    hybrid_scores = defaultdict(float)

                    for rec in collaborative_recs:
                        if rec['game_id'] not in rated_game_ids:
                            hybrid_scores[rec['game_id']] += (1.0 / rec['rank']) * 0.7

                    for rec in content_recs:
                        if rec['recommend_game_id'] not in rated_game_ids:
                            hybrid_scores[rec['recommend_game_id']] += (1.0 / rec['recommend_content_rank']) * 0.3

                    final_rankings = sorted(hybrid_scores.items(), key=lambda x: x[1], reverse=True)[:30]

                    recommendations = [{
                        'user_id': user_id[0],
                        'game_id': game_id,
                        'recommend_rank': rank
                    } for rank, (game_id, _) in enumerate(final_rankings, 1)]

                    self.save_hybrid_recommendations(recommendations)

                except Exception as e:
                    logger.error(f"Error generating recommendations for user {user_id[0]}: {str(e)}")
                    continue

            return {"message": "Successfully generated hybrid recommendations"}

        except Exception as e:
            logger.error(f"Error generating all hybrid recommendations: {str(e)}")
            return {"message": f"Error generating recommendations: {str(e)}"}
