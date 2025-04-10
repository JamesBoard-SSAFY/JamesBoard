package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Schema(description = "내 정보 조회")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserProfileResponseDto {

    @Schema(description = "사용자 프로필 이미지 URL", example = "https://example.com/profile.png")
    private String userProfile;

    @Schema(description = "사용자 닉네임", example = "두X현")
    private String userNickname;
}
