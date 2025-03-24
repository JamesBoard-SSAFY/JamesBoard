import numpy as np
from datetime import datetime
from sqlalchemy.orm import Session
import models
from typing import List, Dict
from sentence_transformers import SentenceTransformer
import faiss
import pickle
import os
import time

class RecommendationEngine:
    def __init__(self, db: Session):
        self.db = db
        start_time = time.time()
        print("Initializing SBERT model...")
        # SBERT 모델 초기화
        self.model = SentenceTransformer("stsb-roberta-large")
        print(f"SBERT model initialization completed in {time.time() - start_time:.2f} seconds")
        self._initialize_embeddings()

    def _load_items_from_db(self) -> List[Dict]:
        # 데이터베이스에서 게임 데이터 로드
        games = self.db.query(models.Game).all()
        return [
            {
                'game_id': game.game_id,
                'game_title': game.game_title,
                'game_description': game.game_description
            }
            for game in games
        ]

    def _initialize_embeddings(self):
        start_time = time.time()
        print("Initializing embeddings...")
        # 임베딩 파일 경로
        embedding_file = 'game_embeddings.pkl'
        index_file = 'faiss_index.bin'
        
        if os.path.exists(embedding_file) and os.path.exists(index_file):
            print("Loading existing embeddings and index...")
            # 저장된 임베딩과 인덱스 로드
            with open(embedding_file, 'rb') as f:
                self.items = pickle.load(f)
            self.index = faiss.read_index(index_file)
            print(f"Embeddings and index loaded in {time.time() - start_time:.2f} seconds")
        else:
            print("Computing new embeddings...")
            # 새로운 임베딩 계산
            self.items = self._load_items_from_db()
            sentences = [item.get('game_description', '') for item in self.items]
            
            if sentences:
                # 임베딩 계산
                self.embeddings = self.model.encode(sentences)
                
                # FAISS 인덱스 생성
                dimension = self.embeddings.shape[1]
                self.index = faiss.IndexFlatL2(dimension)
                self.index.add(self.embeddings.astype('float32'))
                
                # 임베딩과 인덱스 저장
                with open(embedding_file, 'wb') as f:
                    pickle.dump(self.items, f)
                faiss.write_index(self.index, index_file)
                print(f"New embeddings computed and saved in {time.time() - start_time:.2f} seconds")
            else:
                self.embeddings = np.array([])
                self.index = None
                print("No sentences found for embedding computation")

    def calculate_content_recommendations(self, game_id: int, top_n: int = 100) -> List[Dict]:
        if not self.items or self.index is None:
            return []

        start_time = time.time()
        # 게임 인덱스 찾기
        try:
            item_idx = next(i for i, x in enumerate(self.items) if x['game_id'] == game_id)
        except StopIteration:
            raise ValueError(f"Game with id {game_id} not found")

        # FAISS로 유사도 검색
        query_vector = self.embeddings[item_idx].reshape(1, -1).astype('float32')
        distances, indices = self.index.search(query_vector, top_n + 1)  # +1 for self
        
        recommendations = []
        for rank, (idx, distance) in enumerate(zip(indices[0], distances[0]), 1):
            if idx != item_idx:  # 자기 자신 제외
                target_item = self.items[idx]
                similarity_score = 1 / (1 + distance)  # 거리를 유사도로 변환
                recommendations.append({
                    'game_id': target_item['game_id'],
                    'game_title': target_item['game_title'],
                    'recommend_rank': rank,
                    'similarity_score': float(similarity_score)
                })

        print(f"Recommendation calculation completed in {time.time() - start_time:.2f} seconds")
        return recommendations

    def save_recommendations(self, recommendations: List[Dict], game_id: int):
        start_time = time.time()
        # 기존 추천 결과 삭제
        self.db.query(models.GameRecommendation).filter(
            models.GameRecommendation.game_id == game_id
        ).delete()

        # 새로운 추천 결과 저장
        for rec in recommendations:
            recommendation = models.GameRecommendation(
                game_id=game_id,
                recommended_game_id=rec['game_id'],
                similarity_score=rec['similarity_score'],
                recommend_rank=rec['recommend_rank']
            )
            self.db.add(recommendation)
        
        self.db.commit()
        print(f"Recommendations saved to database in {time.time() - start_time:.2f} seconds")

    def get_content_recommendations(self, game_id: int, top_n: int = 100) -> List[Dict]:
        start_time = time.time()
        # 데이터베이스에서 기존 추천 확인
        existing_recs = (
            self.db.query(models.GameRecommendation)
            .filter(models.GameRecommendation.game_id == game_id)
            .order_by(models.GameRecommendation.recommend_rank)
            .limit(top_n)
            .all()
        )
        
        if existing_recs:
            print(f"Retrieved existing recommendations in {time.time() - start_time:.2f} seconds")
            return [
                {
                    'game_id': rec.recommended_game_id,
                    'recommend_rank': rec.recommend_rank,
                    'similarity_score': rec.similarity_score,
                    'created_at': rec.created_at
                }
                for rec in existing_recs
            ]
        
        # 추천이 없는 경우 새로 계산
        recommendations = self.calculate_content_recommendations(game_id, top_n)
        
        # DB에 저장
        self.save_recommendations(recommendations, game_id)
        
        print(f"Total recommendation process completed in {time.time() - start_time:.2f} seconds")
        return recommendations

    def get_recommendations_by_rank(self, game_id: int, start_rank: int = 1, end_rank: int = 100) -> List[Dict]:
        start_time = time.time()
        # 데이터베이스에서 해당 순위 범위의 추천 가져오기
        recommendations = (
            self.db.query(models.GameRecommendation)
            .filter(
                models.GameRecommendation.game_id == game_id,
                models.GameRecommendation.recommend_rank >= start_rank,
                models.GameRecommendation.recommend_rank <= end_rank
            )
            .order_by(models.GameRecommendation.recommend_rank)
            .all()
        )
        
        if not recommendations:
            # 추천이 없는 경우 새로 계산
            all_recommendations = self.get_content_recommendations(game_id)
            recommendations = [
                rec for rec in all_recommendations 
                if start_rank <= rec['recommend_rank'] <= end_rank
            ]
        
        print(f"Retrieved recommendations by rank in {time.time() - start_time:.2f} seconds")
        return recommendations

    def get_category_recommendations(self, category: str, limit: int = 5) -> List[Dict]:
        start_time = time.time()
        # 카테고리별 게임 ID 목록 가져오기
        category_items = self.db.query(models.Game.game_id).filter(
            models.Game.game_difficulty == category
        ).all()
        category_item_ids = [item.game_id for item in category_items]
        
        if not category_item_ids:
            return []
            
        # 카테고리 내 첫 번째 게임에 대한 추천 계산
        base_game_id = category_item_ids[0]
        all_recommendations = self.calculate_content_recommendations(base_game_id, limit=100)
        
        # 카테고리별 추천만 필터링
        category_recommendations = [
            rec for rec in all_recommendations 
            if rec['game_id'] in category_item_ids
        ]
        
        print(f"Retrieved category recommendations in {time.time() - start_time:.2f} seconds")
        return category_recommendations[:limit] 