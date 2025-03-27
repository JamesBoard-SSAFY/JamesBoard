package com.board.jamesboard.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.board.jamesboard.db.entity.Recommend;
import com.board.jamesboard.db.entity.User;

@Repository
public interface RecommendRepository extends JpaRepository<Recommend, Long> {

    // 사용자 기준으로 limit 숫자만큼 게임을 추천
    @Query("SELECT r FROM Recommend r WHERE r.user = :user AND r.recommendRank BETWEEN 1 AND 30 ORDER BY r.recommendRank ASC")
    List<Recommend> findTopNByUserOrderByRecommendRankAsc(User user, Integer limit);
}
