package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.List;

@Schema(description = "사용자 보드게임 통계 및 순위")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserStatsResponseDto {

    @Schema(description = "총 플레이 횟수", example = "72")
    private Integer totalPlayed;

    @Schema(description = " 카테고리별 통계")
    private List<GenreStats> genreStats;

    @Schema(description = "가장 많이 플레이한 게임 목록")
    private List<TopPlayedGame> topPlayedGames;

    @Getter
    @Builder
    @AllArgsConstructor(access = AccessLevel.PROTECTED)
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    public static class GenreStats {

        @Schema(description = "게임 카테고리 이름", example = "파티")
        private String gameCategoryName;

        @Schema(description = "플레이 횟수", example = "24")
        private Integer count;

        @Schema(description = "전체 대비 퍼센티지", example = "33.3")
        private Double percentage;
    }

    @Getter
    @Builder
    @AllArgsConstructor(access = AccessLevel.PROTECTED)
    @NoArgsConstructor(access = AccessLevel.PROTECTED)
    public static class TopPlayedGame {
        @Schema(description = "게임 ID", example = "1")
        private Long gameId;

        @Schema(description = "게임 제목", example = "다빈치 코드")
        private String gameTitle;

        @Schema(description = "게임 이미지", example = "https://example.com/images/davinci.jpg")
        private String gameImage;

        @Schema(description = "총 플레이 횟수", example = "35")
        private Integer totalPlayCount;
    }

}
