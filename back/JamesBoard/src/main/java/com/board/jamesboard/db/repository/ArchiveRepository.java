package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ArchiveRepository extends JpaRepository<Archive, Long> {
    Archive findByArchiveId(Long archiveId);

    // 사용자 ID와 게임 ID로 아카이브 목록 조회 (삭제되지 않은 것만)
    List<Archive> findByUserUserIdAndGameGameIdOrderByCreatedAtDesc(Long userId, Long gameId);
}