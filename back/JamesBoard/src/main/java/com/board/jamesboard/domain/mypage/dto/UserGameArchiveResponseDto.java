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

    @Schema(description = "게임 제목", example = "다빈치 코드")
    private String gameTitle;

    @Schema(description = "게임 이미지 URL", example = "https://example.com/images/davinci.jpg")
    private String gameImage;

    @Schema(description = "게임 카테고리 목록", example = "[\"전략\", \"추리\"]")
    private List<String> gameCategoryList;

    @Schema(description = "최소 연령", example = "15")
    private Integer minAge;

    @Schema(description = "출시 연도", example = "1997")
    private Integer gameYear;

    @Schema(description = "최소 플레이어 수", example = "2")
    private Integer minPlayer;

    @Schema(description = "최대 플레이어 수", example = "4")
    private Integer maxPlayer;

    @Schema(description = "게임 난이도", example = "2")
    private Integer difficulty;

    @Schema(description = "게임 플레이 시간(분)", example = "45")
    private Integer playTime;

    @Schema(description = "아카이브 목록")
    private List<ArchiveDetailDto> archiveList;

    @Getter
    @Builder
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    @AllArgsConstructor(access = AccessLevel.PROTECTED)
    public static class ArchiveDetailDto {

        @Schema(description = "아카이브 ID", example = "101")
        private Long archiveId;

        @Schema(description = "작성일", example = "2025-03-10")
        private String createdAt;

        @Schema(description = "아카이브 내용", example = "친구들과 플레이했는데 너무 재미있었어요!")
        private String archiveContent;

        @Schema(description = "게임 플레이 횟수", example = "3")
        private Integer archiveGamePlayCount;

        @Schema(description = "아카이브 이미지 URL", example = "https://example.com/images/archive1.jpg")
        private String archiveImage;
    }

}

