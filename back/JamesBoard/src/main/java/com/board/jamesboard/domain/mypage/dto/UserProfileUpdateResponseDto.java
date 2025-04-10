package com.board.jamesboard.domain.mypage.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Schema(description = "프로필 수정 응답 DTO")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserProfileUpdateResponseDto {
    @Schema(description = "사용자 ID", example = "1")
    private Long usersId;
}
