package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ArchiveRepository extends JpaRepository<Archive, Long> {
    Archive findByArchiveId(Long archiveId);

    @Query("select distinct a from Archive a join fetch a.archiveImages")
    List<Archive> findAllArchiveWithImage();

    // 사용자 ID와 게임 ID로 아카이브 목록 조회
    List<Archive> findByUserUserIdAndGameGameIdOrderByCreatedAtDesc(Long userId, Long gameId);

    // 총 플레이 횟수 조회
    @Query("SELECT COALESCE(SUM(a.archiveGamePlayCount), 0)" +
            "FROM  Archive a WHERE a.user.userId = :userId"
    )
    Integer getTotalPlayByUserId(@Param("userId") Long userId);

    // 사용자 게임 별 총 플레이 횟수
    @Query("SELECT a.game.gameId, a.game.gameTitle, a.game.bigThumbnail, SUM(a.archiveGamePlayCount) as totalCount " +
            "FROM Archive a " +
            "WHERE a.user.userId = :userId " +
            "GROUP BY a.game.gameId, a.game.gameTitle, a.game.bigThumbnail " +
            "ORDER BY totalCount DESC")
    List<Object[]> getTopPlayGamesByUserId(@Param("userId") Long userId);

    //사용자 카테고리별 게임 플레이 횟수 조회
    @Query("SELECT gc.gameCategoryName, SUM(a.archiveGamePlayCount) as categoryCount " +
            "FROM Archive a " +
            "JOIN a.game g " +
            "JOIN g.gameCategories gc " +
            "WHERE a.user.userId = :userId " +
            "GROUP BY gc.gameCategoryName " +
            "ORDER BY categoryCount DESC")
    List<Object[]> getGenreStatsByUserIdGroupByName(@Param("userId") Long userId);

}