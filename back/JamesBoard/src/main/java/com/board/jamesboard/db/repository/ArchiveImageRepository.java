package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import com.board.jamesboard.db.entity.ArchiveImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ArchiveImageRepository extends JpaRepository<ArchiveImage, Long> {
    List<ArchiveImage> findAllByArchiveIn(List<Archive> archive);

    List<ArchiveImage> findByArchive(Archive archive);

    void deleteArchiveImageByArchive(Archive archive);

    // 아카이브 ID로 이미지 목록 조회
    List<ArchiveImage> findByArchiveArchiveId(Long archiveId);

    // 아카이브 ID로 첫번쨰 이미지 조회
    @Query(value = "SELECT ai.archiveImageUrl FROM ArchiveImage ai " +
            "WHERE ai.archive.archiveId = :archiveId " +
            "ORDER BY ai.archiveImageId ASC LIMIT 1"
                ,nativeQuery = true)
    Optional<String> findFirstImageUrlByArchiveId(@Param("archiveID") Long archiveID);
}
