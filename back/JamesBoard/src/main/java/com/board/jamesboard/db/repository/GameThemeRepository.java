package com.board.jamesboard.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.board.jamesboard.db.entity.GameTheme;

public interface GameThemeRepository extends JpaRepository<GameTheme, Long> {
    List<GameTheme> findByGameThemeName(String themeName);

    // 게임 ID로 테마 이름 목록 조회
    @Query("SELECT gc.gameThemeName FROM GameTheme gc WHERE gc.game.gameId = :gameId")
    List<String> findThemeByGameId(@Param("gameId") Long gameId);

    // 고유 테마 이름 조회(중복제거)
    @Query("SELECT DISTINCT gc.gameThemeName FROM GameTheme gc ORDER BY gc.gameThemeName")
    List<String> findDistinctThemeNames();
}
