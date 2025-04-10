package com.board.jamesboard.core.auth.jwt;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
@Slf4j
public class JWTUtil {
    //액세스 토큰 유효 시간
    @Value("${jwt.expiration.access}")
    private Long accessTokenValidTime;


    //리프레시 토큰 유효시간
    @Value("${jwt.expiration.refresh}")
    private Long refreshTokenValidTime;

    // jwt secret key
    private final SecretKey secretKey;

    public JWTUtil(@Value("${jwt.secret}") String secret) {
        // 문자열 시크릿 키 SecreKey 로 반환
        this.secretKey = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8),
                Jwts.SIG.HS256.key().build().getAlgorithm());

    }

    //토큰 추출
    public String getJwtFromRequest(HttpServletRequest request) {
        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            throw new CustomException(ErrorCode.INVALID_TOKEN_FORM);
        }
        String token = authorization.split(" ")[1];
        return token;
    }

    // 토큰에서 사용자 ID 추출
    public Long getUserId(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(secretKey)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload()
                    .get("userId", Long.class);
        } catch (JwtException | IllegalArgumentException e) {
            log.warn("유효하지 않은 토큰입니다: {}", e.getMessage());
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }

    }

    public boolean isExpired(String token) {
        try{
            // 만료 시간과 현재시간 비교
            Date expiration = Jwts.parser()
                    .verifyWith(secretKey)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload()
                    .getExpiration();
            return expiration.before(new Date());
        } catch (ExpiredJwtException e) {
            // 토큰이 이미 만료된 경우
            throw new CustomException(ErrorCode.EXPIRED_ACCESS_TOKEN);
        } catch (JwtException e) {
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }
    }

    //토큰 생성
    public JWTToken createTokens(Long userId) {
        String accessToken = createToken(userId, accessTokenValidTime);
        String refreshToken = createToken(userId, refreshTokenValidTime);
        return new JWTToken("Bearer", accessToken, refreshToken);
    }

    public String createAccessToken(Long userId){
        return createToken(userId, accessTokenValidTime);
    }

    public String createRefreshToken(Long userId){
        return createToken(userId, refreshTokenValidTime);
    }


    public String createToken(Long userId, Long expiredMS) {
        return Jwts.builder()
                .claim("userId", userId) // userId 저장
                .issuedAt(new Date(System.currentTimeMillis())) //발급 시간
                .expiration(new Date(System.currentTimeMillis() + expiredMS)) //만료 시간
                .signWith(secretKey)
                .compact();
    }

    // 토큰 갱신
    public JWTToken refresh(String refreshToken) {
        if (verifyRefreshToken(refreshToken)) {
            Long userId = getUserId(refreshToken);
            String accessToken = createAccessToken(userId);
            return new JWTToken("Bearer", accessToken, createRefreshToken(userId));
        }
        return null;
    }

    // 액세스 토큰 갱신 (리프레시 X)
    public JWTToken refreshAccessTokenOnly(String refreshToken) {
        if (verifyRefreshToken(refreshToken)) {
            Long userId = getUserId(refreshToken);
            String newAccessToken = createAccessToken(userId);

            // 기존 리프레시 유지
            return new JWTToken("Bearer", newAccessToken, refreshToken);
        }
        return null;
    }

    // refresh 토큰 유효성 검사
    public Boolean verifyRefreshToken(String token) {
        try {
            Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token);
            return true;
        } catch (JwtException e) {
            log.error("리프리시 토큰 검증 실패 : {}", e.getMessage());
            throw new CustomException(ErrorCode.INVALID_REFRESH_TOKEN);
        }
    }

}
