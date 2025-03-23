import numpy as np
from datetime import datetime
from sqlalchemy.orm import Session
import models
from typing import List, Dict
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
from sklearn.cluster import KMeans

class RecommendationEngine:
    def __init__(self, db: Session):
        self.db = db
        # SBERT 모델 초기화
        self.model = SentenceTransformer("stsb-roberta-large")
        self._initialize_embeddings()

    def _load_items_from_external_source(self) -> List[Dict]:
        # 테스트용 더미 데이터
        return [
            {
                'id': 1,
                'title': '테스트 게임 1',
                'description_detail': '전략 시뮬레이션 게임입니다.',
                'category': '전략'
            },
            {
                'id': 2,
                'title': '테스트 게임 2',
                'description_detail': '롤플레잉 어드벤처 게임입니다.',
                'category': 'RPG'
            },
            {
                'id': 3,
                'title': '테스트 게임 3',
                'description_detail': '퍼즐 게임입니다.',
                'category': '퍼즐'
            }
        ]

    def _initialize_embeddings(self):
        # 외부 소스에서 아이템 데이터 로드
        self.items = self._load_items_from_external_source()
        
        # 텍스트 데이터 준비
        sentences = []
        for item in self.items:
            # description_detail과 category를 결합
            text = f"{item.get('description_detail', '')} {item.get('category', '')}"
            sentences.append(text)
        
        if sentences:  # 문장이 있을 때만 임베딩 계산
            # 임베딩 계산
            self.embeddings = self.model.encode(sentences)
            # 코사인 유사도 계산
            self.cosine_sim = cosine_similarity(self.embeddings, self.embeddings)
        else:
            # 데이터가 없을 경우 빈 배열로 초기화
            self.embeddings = np.array([])
            self.cosine_sim = np.array([])

    def calculate_content_recommendations(self, item_id: int, top_n: int = 10) -> List[Dict]:
        if not self.items:
            return []

        # 아이템 인덱스 찾기
        try:
            item_idx = next(i for i, x in enumerate(self.items) if x['id'] == item_id)
        except StopIteration:
            raise ValueError(f"Item with id {item_id} not found")

        # 코사인 유사도 기반 추천
        sim_scores = list(enumerate(self.cosine_sim[item_idx]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)[1:top_n+1]
        
        recommendations = []
        for rank, (idx, score) in enumerate(sim_scores, 1):
            target_item = self.items[idx]
            if target_item['id'] != item_id:  # 자기 자신 제외
                recommendations.append({
                    'source_item_id': item_id,
                    'target_item_id': target_item['id'],
                    'similarity_score': float(score),
                    'game_rank': rank
                })

        return recommendations

    def save_content_recommendations(self, recommendations: List[Dict]):
        for rec in recommendations:
            # 기존 추천 결과가 있다면 삭제
            self.db.query(models.ContentRecommendation).filter(
                models.ContentRecommendation.source_item_id == rec['source_item_id'],
                models.ContentRecommendation.target_item_id == rec['target_item_id']
            ).delete()

            # 새로운 추천 결과 저장
            recommendation = models.ContentRecommendation(
                source_item_id=rec['source_item_id'],
                target_item_id=rec['target_item_id'],
                similarity_score=rec['similarity_score'],
                game_rank=rec['game_rank'],
                created_at=datetime.now(),
                updated_at=datetime.now()
            )
            self.db.add(recommendation)
        
        self.db.commit()

    def get_content_recommendations(self, item_id: int, top_n: int = 10) -> List[Dict]:
        # 추천 계산
        recommendations = self.calculate_content_recommendations(item_id, top_n)
        
        # DB에 저장
        self.save_content_recommendations(recommendations)
        
        # 상세 정보 추가
        detailed_recommendations = []
        for rec in recommendations:
            target_item = next((item for item in self.items if item['id'] == rec['target_item_id']), None)
            
            if target_item:
                detailed_recommendations.append({
                    'item_id': target_item['id'],
                    'title': target_item.get('title', ''),
                    'category': target_item.get('category', ''),
                    'similarity_score': rec['similarity_score'],
                    'game_rank': rec['game_rank']
                })
        
        return detailed_recommendations

    def get_category_recommendations(self, user_id: int, category: str, limit: int = 5) -> List[Dict]:
        # 카테고리별 아이템 ID 목록 가져오기
        category_items = self.db.query(models.Item.id).filter(
            models.Item.category == category
        ).all()
        category_item_ids = [item.id for item in category_items]
        
        # 전체 추천 목록 가져오기
        all_recommendations = self.calculate_content_recommendations(user_id, limit=100)
        
        # 카테고리별 추천만 필터링
        category_recommendations = [
            rec for rec in all_recommendations 
            if rec['item_id'] in category_item_ids
        ]
        
        return category_recommendations[:limit]

class GameRecommender:
    def __init__(self):
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.game_data = None
        self.embeddings = None
        self.ratings_data = None
        self.pivot_table = None
        self.kmeans = None
        
    def load_data(self, games_df: pd.DataFrame, ratings_df: pd.DataFrame):
        # 게임 데이터 로드 및 임베딩 계산
        self.game_data = games_df
        descriptions = games_df['description'].tolist()
        self.embeddings = self.model.encode(descriptions)
        
        # 평점 데이터 로드
        self.ratings_data = ratings_df
        self._prepare_collaborative_data()
        
    def _prepare_collaborative_data(self):
        # 평점 데이터 정제
        ratings = self.ratings_data.copy()
        ratings = ratings.dropna(subset=["user", "rating", "name"])
        ratings["user"] = ratings["user"].str.strip()
        ratings["rating"] = ratings["rating"].round(2)
        ratings["name"] = ratings["name"].str.strip()
        ratings = ratings[ratings["rating"] > 0]
        
        # 피벗 테이블 생성
        self.pivot_table = ratings.pivot_table(index="user", columns="name", values="rating")
        self.pivot_table = self.pivot_table.dropna(axis=0, how="all")
        
        # K-means 클러스터링 수행
        self.kmeans = KMeans(n_clusters=5000, random_state=42)
        self.kmeans.fit(self.pivot_table.fillna(0))
        self.pivot_table["cluster"] = self.kmeans.labels_
        
    def get_collaborative_recommendations(self, user_id: str, played_games: List[str], top_k: int = 5) -> List[Dict]:
        if user_id not in self.pivot_table.index:
            return []
            
        user_cluster = self.pivot_table.loc[user_id, "cluster"]
        cluster_users = self.pivot_table[self.pivot_table["cluster"] == user_cluster].drop(columns=["cluster"])
        
        # 클러스터 내 게임들의 평균 평점 계산
        recommendations = cluster_users.mean(skipna=True).sort_values(ascending=False)
        recommendations = recommendations[~recommendations.index.isin(played_games)]
        
        # 딕셔너리 리스트로 변환
        collab_recs = []
        for rank, (game_name, score) in enumerate(recommendations.head(top_k).items(), 1):
            game_id = self.game_data[self.game_data['name'] == game_name]['id'].iloc[0]
            collab_recs.append({
                'recommended_game_id': int(game_id),
                'similarity_score': float(score),
                'rank': rank
            })
            
        return collab_recs
        
    def find_similar_games(self, game_id: int, top_k: int = 5) -> List[Dict]:
        if self.game_data is None or self.embeddings is None:
            raise ValueError("게임 데이터가 로드되지 않았습니다. load_data를 먼저 호출하세요.")
            
        # 게임의 임베딩 가져오기
        game_idx = self.game_data.index[self.game_data['id'] == game_id].tolist()[0]
        game_embedding = self.embeddings[game_idx]
        
        # 유사도 계산
        similarities = np.dot(self.embeddings, game_embedding) / (
            np.linalg.norm(self.embeddings, axis=1) * np.linalg.norm(game_embedding)
        )
        
        # 상위 유사 게임 가져오기 (자기 자신 제외)
        similar_indices = np.argsort(similarities)[::-1][1:top_k+1]
        
        recommendations = []
        for rank, idx in enumerate(similar_indices, 1):
            similar_game = self.game_data.iloc[idx]
            recommendations.append({
                'recommended_game_id': int(similar_game['id']),
                'similarity_score': float(similarities[idx]),
                'rank': rank
            })
            
        return recommendations
        
    def get_hybrid_recommendations(self, user_id: str, game_id: int, top_k: int = 5) -> List[Dict]:
        # 사용자가 플레이한 게임 목록 가져오기
        played_games = self.ratings_data[self.ratings_data["user"] == user_id]["name"].unique().tolist()
        
        # 사용자의 평점 수가 충분한지 확인
        if len(played_games) < 30:
            # 평점이 부족한 경우 콘텐츠 기반 필터링만 사용
            return self.find_similar_games(game_id, top_k)
            
        # 두 가지 추천 방식의 결과 가져오기
        content_recs = self.find_similar_games(game_id, top_k * 2)  # 혼합을 위해 더 많은 추천 가져오기
        collab_recs = self.get_collaborative_recommendations(user_id, played_games, top_k * 2)
        
        if not collab_recs:  # 협업 필터링 실패 시
            return content_recs[:top_k]
            
        # 조회를 위한 딕셔너리 생성
        content_scores = {rec['recommended_game_id']: rec['similarity_score'] for rec in content_recs}
        collab_scores = {rec['recommended_game_id']: rec['similarity_score'] for rec in collab_recs}
        
        # 가중치를 적용하여 점수 결합
        all_games = set(content_scores.keys()) | set(collab_scores.keys())
        hybrid_scores = {}
        
        for game_id in all_games:
            content_score = content_scores.get(game_id, 0)
            collab_score = collab_scores.get(game_id, 0)
            # 가중치 적용: 콘텐츠 기반 0.3, 협업 필터링 0.7
            hybrid_scores[game_id] = (0.3 * content_score) + (0.7 * collab_score)
            
        # 하이브리드 점수로 정렬
        sorted_games = sorted(hybrid_scores.items(), key=lambda x: x[1], reverse=True)
        
        recommendations = []
        for rank, (game_id, score) in enumerate(sorted_games[:top_k], 1):
            recommendations.append({
                'recommended_game_id': game_id,
                'similarity_score': score,
                'rank': rank
            })
            
        return recommendations
        
    def save_recommendations(self, db: Session, recommendations: List[Dict], source_game_id: int):
        """추천 결과를 데이터베이스에 저장합니다"""
        for rec in recommendations:
            db_rec = models.ContentRecommendation(
                source_item_id=source_game_id,
                target_item_id=rec['recommended_game_id'],
                similarity_score=rec['similarity_score'],
                game_rank=rec['rank']
            )
            db.add(db_rec)
        db.commit()

    def get_recommendations(self, db: Session, game_id: int, user_id: str = None, top_k: int = 5) -> List[Dict]:
        """게임에 대한 추천을 데이터베이스에서 가져오거나 새로 계산합니다"""
        # 데이터베이스에서 기존 추천 확인
        existing_recs = (
            db.query(models.ContentRecommendation)
            .filter(models.ContentRecommendation.source_item_id == game_id)
            .order_by(models.ContentRecommendation.game_rank)
            .limit(top_k)
            .all()
        )
        
        if existing_recs and not user_id:  # 사용자별 추천이 아닌 경우에만 캐시 사용
            return [
                {
                    'recommended_game_id': rec.target_item_id,
                    'similarity_score': rec.similarity_score,
                    'rank': rec.game_rank
                }
                for rec in existing_recs
            ]
            
        # 추천이 없거나 사용자별 추천인 경우
        if user_id:
            recommendations = self.get_hybrid_recommendations(user_id, game_id, top_k)
        else:
            recommendations = self.find_similar_games(game_id, top_k)
            
        if not user_id:  # 사용자별 추천이 아닌 경우에만 캐시
            self.save_recommendations(db, recommendations, game_id)
        
        return recommendations 