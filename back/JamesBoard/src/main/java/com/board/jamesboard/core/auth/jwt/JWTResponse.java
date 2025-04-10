package com.board.jamesboard.core.auth.jwt;

import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class JWTResponse {

    private String acccesToken;

    private String refreshToken;

    @Builder
    public JWTResponse(JWTToken token) {
        this.acccesToken = token.getAccessToken();
        this.refreshToken = token.getRefreshToken();
    }
}
