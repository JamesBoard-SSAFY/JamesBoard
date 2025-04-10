package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Schema(description = "사용자 플레이 게임 정보")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class UserGameResponseDto {
    @Schema(description = "게임 ID", example = "1")
    private Long gameId;

    @Schema(description = "게임 이미지 URL", example = "https://example.com/images/davinci.jpg")
    private String gameImage;
}
