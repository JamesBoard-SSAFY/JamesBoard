package com.board.jamesboard.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.RecommendContent;

@Repository
public interface RecommendContentRepository extends JpaRepository<RecommendContent, Long> {
    // 게임 기준으로 유사도가 높은 순서로 10개(limit 만큼) 반환
    @Query("SELECT rc FROM RecommendContent rc JOIN FETCH rc.game g LEFT JOIN FETCH g.gameThemes JOIN FETCH rc.recommendGame rg LEFT JOIN FETCH rg.gameThemes WHERE rc.game = :game AND rc.recommendContentRank BETWEEN 1 AND 30 ORDER BY rc.recommendContentRank ASC")
    List<RecommendContent> findTopNByGameOrderByRecommendContentRankAsc(Game game, Integer limit);
}
