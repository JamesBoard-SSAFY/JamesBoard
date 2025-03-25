package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Game;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GameRepository extends JpaRepository<Game,Long> {
    List<Game> findTop30ByGameIdInOrderByGameRank(List<Long> gameIds);

    // 게임 ID로 게임정보 조회
    Optional<Game> findByGameID(Long gameId);
}
