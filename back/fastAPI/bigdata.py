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
from sqlalchemy import text

class RecommendationEngine:
    def __init__(self, db: Session):
        self.db = db
        self.model = SentenceTransformer("stsb-roberta-large")
        self.embeddings = None  # 명시적으로 초기화
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
        print("Initializing embeddings...")
        # 임베딩 파일 경로
        embedding_file = 'game_embeddings.pkl'
        index_file = 'faiss_index.bin'
        
        # 데이터베이스에서 게임 데이터 로드
        self.items = self._load_items_from_db()
        
        if os.path.exists(embedding_file) and os.path.exists(index_file):
            print("Loading existing embeddings and index...")
            # 저장된 임베딩과 인덱스 로드
            with open(embedding_file, 'rb') as f:
                saved_items = pickle.load(f)
                # 저장된 데이터와 현재 데이터가 일치하는지 확인
                if len(saved_items) == len(self.items):
                    self.items = saved_items
                    self.index = faiss.read_index(index_file)
                    # 임베딩 다시 계산
                    sentences = [item.get('game_description', '') for item in self.items]
                    self.embeddings = self.model.encode(sentences)
                    return
        
        print("Computing new embeddings...")
        # 새로운 임베딩 계산
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
            print("New embeddings computed and saved")
        else:
            print("No sentences found for embedding computation")
            self.embeddings = np.array([])
            self.index = None

    def calculate_content_recommendations(self, game_id: int, top_n: int = 30) -> List[Dict]:
        if not self.items or self.index is None:
            return []

        try:
            item_idx = next(i for i, x in enumerate(self.items) if x['game_id'] == game_id)
        except StopIteration:
            raise ValueError(f"Game with id {game_id} not found")

        # FAISS로 유사도 검색
        query_vector = self.embeddings[item_idx].reshape(1, -1).astype('float32')
        distances, indices = self.index.search(query_vector, top_n + 1)  # +1 for self
        
        recommendations = []
        current_rank = 1
        
        for idx, distance in zip(indices[0], distances[0]):
            if idx != item_idx:  # 자기 자신 제외
                target_item = self.items[idx]
                recommendations.append({
                    'game_id': game_id,  # 선택된 게임 ID
                    'recommend_game_id': target_item['game_id'],  # 추천하는 게임 ID
                    'recommend_content_rank': current_rank  # 추천 순위
                })
                current_rank += 1
                
                if len(recommendations) >= top_n:  # 30개까지만 추천
                    break

        return recommendations

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
            recommendations = (
                self.db.query(models.RecommendContent)
                .filter(models.RecommendContent.game_id == game_id)
                .order_by(models.RecommendContent.recommend_content_rank)
                .limit(top_n)
                .all()
            )
            
            if recommendations:
                return recommendations
            
            # 추천이 없는 경우 새로 계산
            new_recommendations = self.calculate_content_recommendations(game_id, top_n)
            self.save_recommendations(new_recommendations, game_id)
            
            # 저장된 추천 다시 조회
            return (
                self.db.query(models.RecommendContent)
                .filter(models.RecommendContent.game_id == game_id)
                .order_by(models.RecommendContent.recommend_content_rank)
                .limit(top_n)
                .all()
            )
            
        except Exception as e:
            print(f"Error in get_content_recommendations: {str(e)}")
            return []

    def get_hybrid_recommendations(self, game_id: int, user_id: int, top_n: int = 100) -> List[Dict]:
        """하이브리드 필터링을 위한 메서드 (기존 recommend 테이블 사용)"""
        start_time = time.time()
        # 데이터베이스에서 기존 추천 확인
        existing_recs = (
            self.db.query(models.Recommend)
            .filter(
                models.Recommend.game_id == game_id,
                models.Recommend.user_id == user_id
            )
            .order_by(models.Recommend.recommend_rank)
            .limit(top_n)
            .all()
        )
        
        if existing_recs:
            print(f"Retrieved existing hybrid recommendations in {time.time() - start_time:.2f} seconds")
            return existing_recs
        
        # TODO: 하이브리드 추천 로직 구현
        return []

    def get_recommendations_by_rank(self, game_id: int, start_rank: int = 1, end_rank: int = 30) -> List[Dict]:
        """콘텐츠 기반 추천의 특정 순위 범위 조회"""
        try:
            recommendations = (
                self.db.query(models.RecommendContent)
                .filter(
                    models.RecommendContent.game_id == game_id,
                    models.RecommendContent.recommend_content_rank >= start_rank,
                    models.RecommendContent.recommend_content_rank <= end_rank
                )
                .order_by(models.RecommendContent.recommend_content_rank)
                .all()
            )
            
            if recommendations:
                return recommendations
                
            # 추천이 없는 경우 새로 계산
            all_recommendations = self.calculate_content_recommendations(game_id, end_rank)
            self.save_recommendations(all_recommendations, game_id)
            
            return (
                self.db.query(models.RecommendContent)
                .filter(
                    models.RecommendContent.game_id == game_id,
                    models.RecommendContent.recommend_content_rank >= start_rank,
                    models.RecommendContent.recommend_content_rank <= end_rank
                )
                .order_by(models.RecommendContent.recommend_content_rank)
                .all()
            )
            
        except Exception as e:
            print(f"Error in get_recommendations_by_rank: {str(e)}")
            return []

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