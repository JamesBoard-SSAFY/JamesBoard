package com.board.jamesboard.domain.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor // 외부 객체 생성자 허용
@Builder
@Schema(description = "카카오 토큰 로그인 요청 dto")
public class KakaoTokenRequestDto {
    @Schema(description = "카카오 엑세스 토큰", example = "xxxxx")
    private String kakaoAccessToken;

}
