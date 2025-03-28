package com.board.jamesboard.db.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.board.jamesboard.db.entity.Game;

public interface GameRepository extends JpaRepository<Game,Long> {
    List<Game> findTop30ByGameIdInOrderByGameRank(List<Long> gameIds);

    // 게임 ID로 게임정보 조회
    Optional<Game> findByGameId(Long gameId);
}
