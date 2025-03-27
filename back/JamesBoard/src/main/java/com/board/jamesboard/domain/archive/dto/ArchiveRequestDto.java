package com.board.jamesboard.domain.archive.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArchiveRequestDto {
    private Long gameId;
    private String archiveContent;
    private List<String> archiveImageList;
    private Integer archiveGamePlayTime;
    private Integer archiveGamePlayCount;
}
