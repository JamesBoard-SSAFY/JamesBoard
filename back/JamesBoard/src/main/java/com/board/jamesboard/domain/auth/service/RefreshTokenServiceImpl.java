package com.board.jamesboard.domain.auth.service;

import com.board.jamesboard.core.auth.jwt.JWTToken;
import com.board.jamesboard.core.auth.jwt.JWTUtil;
import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.db.entity.RefreshToken;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.RefreshTokenRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.nimbusds.jwt.JWT;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class RefreshTokenServiceImpl implements RefreshTokenService {

    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;
    private final JWTUtil jwtUtil;

    @Override
    @Transactional
    public RefreshToken saveRefreshToken(Long userId, String token) {
        try {
            //사용자 조회
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

            //기존 refresh 확인 및 삭제
            refreshTokenRepository.deleteByUserUserId(userId);
            refreshTokenRepository.flush(); // DB에 즉시 반영


            // 새 토큰 생성 및 저장
            RefreshToken refreshToken = RefreshToken.builder()
                    .user(user)
                    .token(token)
                    .createdAt(Instant.now())
                    .modifiedAt(Instant.now())
                    .build();
            return refreshTokenRepository.save(refreshToken);
        } catch (DataIntegrityViolationException e) {
            log.warn("리프레시 토큰 저장 중 무결성 제약 조건 위반 발생 : {}", e.getMessage());

            // 동시성 이슈 발생 시 재시도
            refreshTokenRepository.deleteByUserUserId(userId);
            refreshTokenRepository.flush(); // DB에 즉시 반영

            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

            // 새 토큰 생성 및 저장
            RefreshToken refreshToken = RefreshToken.builder()
                    .user(user)
                    .token(token)
                    .createdAt(Instant.now())
                    .modifiedAt(Instant.now())
                    .build();
            return refreshTokenRepository.save(refreshToken);
        }


    }

    // 새 토큰 발급
    @Override
    @Transactional
    public JWTToken refreshToken(String refreshToken) {
        try {
            //토큰 검증
            if (!jwtUtil.verifyRefreshToken(refreshToken)) {
                log.error("유효하지 않은 리프레시 토큰입니다");
                throw new CustomException(ErrorCode.INVALID_REFRESH_TOKEN);
            }

            //DB 토큰 조회
            RefreshToken tokenEntity = refreshTokenRepository.findByToken(refreshToken)
                    .orElseThrow(() -> {
                        log.error("저장된 리프레시 토큰이 없습니다");
                        return new CustomException(ErrorCode.UNAUTHORIZED);

                    });

            // 액세스 토큰만 갱신, 리프레시 토큰은 유지
            JWTToken newTokens = jwtUtil.refreshAccessTokenOnly(refreshToken);

            log.info("액세스 토큰 갱신 완료");

            return newTokens;
        } catch (CustomException e) {
            throw e;
        } catch (Exception e) {
            log.error("토큰 갱신 중 오류 발생 : {}", e.getMessage());
            throw new CustomException(ErrorCode.INTERNAL_SERVER_ERROR);
        }

    }

    // userId로 리프레시 토큰 조회
    @Override
    public Optional<RefreshToken> findByUserId(Long userId) {
        return refreshTokenRepository.findByUserUserId(userId);
    }

    // 토큰 값으로 리프레시 토큰 조회
    @Override
    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    // 토큰 삭제 (로그아웃)
    @Override
    @Transactional
    public void deleteByUserUserId(Long userId) {
        refreshTokenRepository.deleteByUserUserId(userId);
        log.info("사용자 ID {} 의 리프레시 토큰이 삭제되었습니다", userId);
    }



}
