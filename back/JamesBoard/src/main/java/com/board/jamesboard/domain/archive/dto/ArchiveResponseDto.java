package com.board.jamesboard.domain.archive.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArchiveResponseDto {
    private Long archiveId;
    private String archiveImage;
}
