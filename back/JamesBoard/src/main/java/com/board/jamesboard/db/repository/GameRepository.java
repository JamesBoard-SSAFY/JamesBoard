package com.board.jamesboard.db.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.board.jamesboard.db.entity.Game;

public interface GameRepository extends JpaRepository<Game,Long> {
    List<Game> findTop30ByGameIdInOrderByGameRank(List<Long> gameIds);

    @Query("SELECT g FROM Game g LEFT JOIN FETCH g.gameCategories")
    List<Game> findAllWithCategories();

    // 게임 ID로 게임정보 조회
    Optional<Game> findByGameId(Long gameId);

    // 게임 순위로 정렬하여 상위 게임 조회
    @Query(value = "SELECT * FROM game ORDER BY game_rank ASC LIMIT :limit", nativeQuery = true)
    List<Game> findTopGamesByRank(@Param("limit") int limit);

    // 평균 평점으로 정렬하여 상위 게임 조회
    @Query(value = "SELECT * FROM game ORDER BY game_avg_rating DESC LIMIT :limit", nativeQuery = true)
    List<Game> findTopGamesByRating(@Param("limit") int limit);
}
