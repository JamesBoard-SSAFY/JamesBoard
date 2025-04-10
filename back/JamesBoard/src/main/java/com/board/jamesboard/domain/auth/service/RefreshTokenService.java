package com.board.jamesboard.domain.auth.service;

import com.board.jamesboard.core.auth.jwt.JWTToken;
import com.board.jamesboard.db.entity.RefreshToken;

import java.util.Optional;

public interface RefreshTokenService {
    // refresh 저장 or 갱신
    RefreshToken saveRefreshToken(Long userId, String token);

    // refresh 새 토큰세트 발급
    JWTToken refreshToken(String refreshToken);

    Optional<RefreshToken> findByToken(String token);

    // 사용자 ID를 통한 토큰 조회
    Optional<RefreshToken> findByUserId(Long userId);

    // 토큰 삭제
    void deleteByUserUserId(Long userId);

}
