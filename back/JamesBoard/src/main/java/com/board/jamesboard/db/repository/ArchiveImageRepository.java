package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import com.board.jamesboard.db.entity.ArchiveImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;

public interface ArchiveImageRepository extends JpaRepository<ArchiveImage, Long> {
    List<ArchiveImage> findAllByArchiveIn(List<Archive> archive);

    List<ArchiveImage> findByArchive(Archive archive);

    void deleteArchiveImageByArchive(Archive archive);
}
