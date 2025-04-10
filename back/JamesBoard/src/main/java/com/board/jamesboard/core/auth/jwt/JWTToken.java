package com.board.jamesboard.core.auth.jwt;

import lombok.*;

@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class JWTToken {

    private String grantType;

    private String accessToken;

    private String refreshToken;

}
