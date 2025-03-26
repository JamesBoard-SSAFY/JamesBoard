package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.GameCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface GameCategoryRepository extends JpaRepository<GameCategory, Long> {
    List<GameCategory> findByGameCategoryName(String category);

    // 게임 ID로 카테고리 이름 목록 조회
    @Query("SELECT gc.gameCategoryName FROM GameCategory  gc WHERE gc.game.gameId = :gameId")
    List<String> findCategoryNamesByGameId(@Param("gameId") Long gameId);
}
