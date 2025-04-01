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
public class ArchiveDetailResponseDto {
    private Long archiveId;
    private Long userId;
    private String userNickName;
    private String userProfile;
    private String archiveContent;
    private String gameTitle;
    private Integer archiveGamePlayTime;
    private Integer archiveGamePlayCount;
    private List<String> archiveImageList;
}
