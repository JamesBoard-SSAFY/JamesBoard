package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Schema(description = "프로필 수정 요청DTO")
@Getter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserProfileUpdateRequestDto {
    @Schema(description = "사용자 이름", example = "장킨스")
    private String userName;

    @Schema(description = "사용자 프로필 이미지 URL", example = "profileImageURL.jpg")
    private String userProfile;
}
