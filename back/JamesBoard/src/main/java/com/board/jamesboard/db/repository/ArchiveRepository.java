package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ArchiveRepository extends JpaRepository<Archive, Long> {
    Archive findByArchiveId(Long archiveId);
}