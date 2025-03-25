package com.board.jamesboard.domain.archive.service;

import com.board.jamesboard.domain.archive.dto.ArchiveDetailResponseDto;
import com.board.jamesboard.domain.archive.dto.ArchiveRequestDto;
import com.board.jamesboard.domain.archive.dto.ArchiveResponseDto;

import java.util.List;

public interface ArchiveService {
    List<ArchiveResponseDto> getArchivesImage();

    ArchiveDetailResponseDto getArchiveDetail(Long archiveId);

    Long createArchive(ArchiveRequestDto archiveRequestDto);

    Long updateArchive(Long archiveId, ArchiveRequestDto archiveRequestDto);

    Long deleteArchive(Long archiveId);
}
