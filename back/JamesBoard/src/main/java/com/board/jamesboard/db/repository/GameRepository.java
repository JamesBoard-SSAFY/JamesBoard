package com.board.jamesboard.db.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.board.jamesboard.db.entity.Game;

public interface GameRepository extends JpaRepository<Game,Long>, GameRepositoryCustom {
    List<Game> findTop30ByGameIdInOrderByGameRank(List<Long> gameIds);

    // 게임 ID로 게임정보 조회
    Optional<Game> findByGameId(Long gameId);

    @Query("SELECT DISTINCT g FROM Game g " +
            "LEFT JOIN FETCH g.gameThemes " +
            "WHERE g.gameId IN :gameIds")
    List<Game> findGamesByGameIdsWithThemes(@Param("gameIds") List<Long> gameIds);

    @Query("SELECT DISTINCT g FROM Game g " +
            "LEFT JOIN FETCH g.gameCategories " +
            "WHERE g.gameId IN :gameIds")
    List<Game> findGamesByGameIdsWithCategories(@Param("gameIds") List<Long> gameIds);

    @Query("SELECT DISTINCT g.gameId FROM Game g " +
            "JOIN g.gameCategories gc " +
            "WHERE (:difficulty IS NULL OR g.gameDifficulty = :difficulty) AND " +
            "(:minPlayers IS NULL OR g.minPlayer >= :minPlayers) AND " +
            "(:name IS NULL OR g.gameTitle LIKE %:name%) AND " +
            "(:category IS NULL OR gc.gameCategoryName = :category) AND " +
            "(:minPlayTime IS NULL OR g.gamePlayTime >= :minPlayTime) AND " +
            "(:maxPlayTime IS NULL OR g.gamePlayTime <= :maxPlayTime)")
    List<Long> findFilteredGameIds(Integer difficulty, Integer minPlayers, String name, String category, Integer minPlayTime, Integer maxPlayTime);


    // 게임 순위로 정렬하여 상위 게임 조회
    @Query(value = "SELECT * FROM game ORDER BY game_rank ASC LIMIT :limit", nativeQuery = true)
    List<Game> findTopGamesByRank(@Param("limit") int limit);

    // 평균 평점으로 정렬하여 상위 게임 조회
    @Query(value = "SELECT * FROM game ORDER BY game_avg_rating DESC LIMIT :limit", nativeQuery = true)
    List<Game> findTopGamesByRating(@Param("limit") int limit);
}
