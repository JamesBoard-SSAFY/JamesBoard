package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.List;

@Schema(description = "게임에 대한 작성 아카이브 조회 응답DTO")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class UserGameArchiveResponseDto {

    private String gameTitle;

    private String gameImage;

    private List<String> gameCategoryList;

    private Integer minPlayer;

    private Integer maxPlayer;

    private Integer difficulty;

    private Integer playTime;


    @Getter
    @Builder
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    @AllArgsConstructor(access = AccessLevel.PROTECTED)
    public static class ArchiveDetailDto {

        private Long archiveId;

        private String createdAt;

        private String archiveContent;

        private Integer archiveGamePlayCount;

        private String archiveImage;
    }

}

