package com.board.jamesboard.domain.auth.service;

import com.board.jamesboard.core.auth.jwt.JWTToken;
import com.board.jamesboard.core.auth.jwt.JWTUtil;
import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.auth.dto.RefreshTokenResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import org.springframework.http.HttpHeaders;

import java.time.Instant;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
    private String clientSecret;

    @Value("${spring.security.oauth2.client.registration.kakao.redirect-uri}")
    private String redirectUri;

    @Value("${spring.security.oauth2.client.provider.kakao.token-uri}")
    private String tokenUri;

    @Value("${spring.security.oauth2.client.provider.kakao.user-info-uri}")
    private String userInfoUri;

    private final UserRepository userRepository;
    private final JWTUtil jwtUtil;
    private final RefreshTokenService refreshTokenService;
    private final RestTemplate restTemplate;

    @Override
    @Transactional
    public RefreshTokenResponseDto refreshToken(String refreshToken) {
        // 새 토큰 발급
        JWTToken newToken = refreshTokenService.refreshToken(refreshToken);
        if (newToken == null) {
            throw new CustomException(ErrorCode.INVALID_REFRESH_TOKEN);
        }

        // 토큰에서 사용자 정보 추출 후 정보조회
        Long userId = jwtUtil.getUserId(refreshToken);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        // 응답 dto 생성 및 반환
        return RefreshTokenResponseDto.builder()
                .accessToken(newToken.getAccessToken())
                .refreshToken(newToken.getRefreshToken())
                .userId(user.getUserId())
                .userProfile(user.getUserProfile())
                .userNickname(user.getUserNickname())
                .build();
    }

    @Override
    @Transactional
    public void logout(Long userId) {

        refreshTokenService.deleteByUserUserId(userId);
        log.info("사용자 로그아웃 처리 완료: userId={}", userId);
    }

    @Override
    @Transactional
    public RefreshTokenResponseDto processKakaoLogin(String code) {
        log.info("카카오 로그인 프로세스 시작 - 인가코드 : {}", code);
        try {
            // 인가 코드로 카카오 토큰 요청하기
            String kakaoAccessToken = getKakaoAccessToken(code);
            log.info("카카오 엑세스 토큰 생성 완료");

            // 토큰으로 사용자 정보 요청하기
            Map<String, Object> userInfo = getKakaoUserInfo(kakaoAccessToken);
            log.info("카카오 사용자 정보 획득 성공: id={}", userInfo.get("id"));

            // 카카오 사용자 정보로 로그인 처리 하기
            return  processUserLogin(userInfo);
        } catch (Exception e) {
            log.error("카카오 로그인 처리 중 오류 발생: {}", e.getMessage(), e);
            throw e;
        }
    }

    public String getKakaoAccessToken(String code) {
        try {
            log.info("토큰 엑세스 요청 시작 - 리다이렉트 URI: {}", redirectUri);

            // 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

            // 요청 바디
            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("grant_type", "authorization_code");
            params.add("client_id", clientId);

            if (clientSecret != null && !clientSecret.isEmpty()) {
                params.add("client_secret", clientSecret);
                log.info("client_secret 추가됨");
            } else {
                log.warn("client_secret이 비어있거나 null 입니다");
            }

            params.add("redirect_uri", redirectUri);
            params.add("code", code);

            // 요청 응답 처리
            HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(params, headers);

            log.info("카카오 토큰 요청 - URL: {}", tokenUri);

            ResponseEntity<Map> response = restTemplate.exchange(
                    tokenUri,
                    HttpMethod.POST,
                    kakaoTokenRequest,
                    Map.class
            );

            log.info("카카오 토큰 응답 상태: {}", response.getStatusCode());

            if (response.getBody() == null) {
                log.error("카카오 사용자 정답 응답 본문 X");
                throw new RestClientException("Empty response body from kakao user info API");
            }

            String accessToken = (String) response.getBody().get("access_token");
            if (accessToken == null || accessToken.isEmpty()) {
                log.error("카카오 액세스 토큰 응답없음");
                throw new RestClientException("No access token is response");
            }

            return accessToken;

        } catch (RestClientException e) {
            log.error("카카오 사용자 정보 API 호출 중 오류: {}", e.getMessage(), e);
            throw e;
        }

    }

    private Map<String, Object> getKakaoUserInfo(String kakaoAccessToken) {
        try {
            log.info("카카오 사용자 정보 요청 시작");
            //요청 헤더
            HttpHeaders headers = new HttpHeaders();
            headers.add("Authorization", "Bearer " + kakaoAccessToken);
            headers.add("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

            // 요청 응답 처리
            HttpEntity<MultiValueMap<String, String>> kakaoUserInfoRequest = new HttpEntity<>(headers);
            ResponseEntity<Map> response = restTemplate.exchange(
                    userInfoUri,
                    HttpMethod.GET,
                    kakaoUserInfoRequest,
                    Map.class
            );

            log.info("카카오 사용자 정보 응답 상태: {}", response.getStatusCode());

            if (response.getBody() == null) {
                log.error("카카오 사용자 정보 응답 본문이 없습니다.");
                throw new RestClientException("Empty response body from kakao user info API");
            }
            return response.getBody();
        } catch (RestClientException e) {
            log.error("카카오 사용자 정보 API 호출 중 오류: {}", e.getMessage(), e);
            throw e;
        }
    }

    private RefreshTokenResponseDto processUserLogin(Map<String, Object> attributes) {
        log.info("사용자 로그인 처리 시작");
        try {
            // 카카오 계정 정보 추출
            Long kakaoId = (Long) attributes.get("id");
            if (kakaoId == null) {
                log.error("카카오 응답에서 ID 정보가 누락됐습니다");
                throw new IllegalArgumentException("Missing ID in Kakao response");
            }

            Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");
            if (kakaoAccount == null) {
                log.error("카카오 응답에서 계정 정보가 누락됐습니다");
                throw new IllegalArgumentException("Missing account info in Kakao response");
            }

            Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
            if (profile == null) {
                log.error("카카오 응답에서 프로필 정보가 누락됐습니다");
                throw new IllegalArgumentException("Missing profile info in Kakao response");
            }

            String loginId = String.valueOf(kakaoId);
            String nickname = (String) profile.get("nickname");
            String userProfile = (String) profile.get("profile_image_url");

            log.info("카카오 사용자 정보 추출 완료: loginId={}, nickname={}", loginId, nickname);

            // DB 사용자 생성 또는 조회
            User user = userRepository.findByLoginId(loginId)
                    .orElseGet(() -> {
                        log.info("새 사용자 생성: loginId={}", loginId);
                        return userRepository.save(User.builder()
                                .loginId(loginId)
                                .userNickname(nickname)
                                .userProfile(userProfile)
                                .build());
                    });

            log.info("사용자 정보 조회/생성 완료: userId={}", user.getUserId());

            // JWT 토큰 생성
            JWTToken jwtToken = jwtUtil.createTokens(user.getUserId());
            log.info("JWT 토큰 생성 완료");

            // 리프레시 토큰 저장
            refreshTokenService.saveRefreshToken(user.getUserId(), jwtToken.getRefreshToken());
            log.info("리프레시 토큰 저장 완료");

            // 응답 반환
            RefreshTokenResponseDto response = RefreshTokenResponseDto.builder()
                    .accessToken(jwtToken.getAccessToken())
                    .refreshToken(jwtToken.getRefreshToken())
                    .userId(user.getUserId())
                    .userNickname(user.getUserNickname())
                    .userProfile(user.getUserProfile())
                    .build();

            log.info("로그인 처리 완료: userId={}", user.getUserId());
            return response;
        } catch (Exception e) {
            log.error("사용자 로그인 처리 중 오류: {}", e.getMessage(), e);
            throw e;
        }
    }

    @Override
    @Transactional
    public RefreshTokenResponseDto processKakaoTokenLogin(String kakaoAccessToken) {
        log.info("카카오 토큰 로그인 프로세스 시작");
        try {
            //엑세스 토큰으로 사용자 정보 요청
            Map<String, Object> userInfo = getKakaoUserInfo(kakaoAccessToken);
            log.info("카카오 사용자 정보 : id={}", userInfo.get("id"));

            //jwt 생성 및 반환
            return processUserLogin(userInfo);
        } catch (Exception e) {
            log.error("카카오 토큰 로그인 처리 중 오류 발생 {}", e.getMessage(), e);
            throw e;
        }

    }

}