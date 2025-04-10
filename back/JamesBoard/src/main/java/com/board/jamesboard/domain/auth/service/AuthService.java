    package com.board.jamesboard.domain.auth.service;

    import com.board.jamesboard.domain.auth.dto.RefreshTokenRequestDto;
    import com.board.jamesboard.domain.auth.dto.RefreshTokenResponseDto;

    public interface AuthService {
        //액세스 토큰 갱신
        RefreshTokenResponseDto refreshToken(String refreshToken);

        //로그아웃 처리( 토큰 삭제 )
        void logout(Long userId);

        //카카오 인가 코드로 로그인 관리
        RefreshTokenResponseDto processKakaoLogin(String code);

        RefreshTokenResponseDto processKakaoTokenLogin(String kakaoAccessToken);
    }
