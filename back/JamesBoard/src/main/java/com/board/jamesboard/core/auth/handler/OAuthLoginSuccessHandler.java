package com.board.jamesboard.core.auth.handler;

import com.board.jamesboard.core.auth.jwt.JWTUtil;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.auth.service.RefreshTokenService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuthLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    private final JWTUtil jwtUtil;
    private final UserRepository userRepository;
    private final RefreshTokenService refreshTokenService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
//        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) authentication;
//        OAuth2User oAuth2User = token.getPrincipal();
//        String provider = token.getAuthorizedClientRegistrationId();
//
//        log.info("OAuth 로그인 성공: provider={}", provider);
//
//        // 카카오 로그인 처리 (확장 가능성 고려)
//        String providerId = extractProviderId(oAuth2User, provider);
//        String nickname = extractNickname(oAuth2User, provider);
//        String profileUrl = extractProfileUrl(oAuth2User, provider);
//
//        // 기존 사용자 확인 또는 신규 등록
//        User user = userRepository.findByLoginId(providerId)
//                .orElseGet(() -> {
//                    log.info("신규 사용자 등록: provider={}, providerId={}", provider, providerId);
//                    return userRepository.save(User.builder()
//                            .loginId(providerId)
//                            .userNickname(nickname)
//                            .userProfile(profileUrl)
//                            .createdAt(Instant.now())
//                            .build());
//                });
//
//        // JWT 토큰 생성
//        JWTToken jwtToken = jwtUtil.createTokens(user.getUserId());
//        log.info("JWT 토큰 생성 완료: userId={}", user.getUserId());
//
//        // 리프레시 토큰 저장
//        refreshTokenService.saveRefreshToken(user.getUserId(), jwtToken.getRefreshToken());
//
//        // 응답 헤더에 액세스 토큰 추가
//        response.setHeader("Authorization", "Bearer " + jwtToken.getAccessToken());
//
//        // 쿠키에 리프레시 토큰 추가
//        addCookie(response, "refreshToken", jwtToken.getRefreshToken(), 60 * 60 * 24 * 7); // 7일
//
//        // 리다이렉트 (프론트엔드 URL로 변경 필요)
//        getRedirectStrategy().sendRedirect(request, response, "/login/oauth2/success");
//    }
//
//    private String extractProviderId(OAuth2User oAuth2User, String provider) {
//        if ("kakao".equals(provider)) {
//            return oAuth2User.getAttribute("id").toString();
//        }
//        // 다른 공급자에 대한 처리 추가 가능
//        return null;
//    }
//
//    private String extractNickname(OAuth2User oAuth2User, String provider) {
//        if ("kakao".equals(provider)) {
//            Map<String, Object> properties = oAuth2User.getAttribute("properties");
//            if (properties != null) {
//                return (String) properties.get("nickname");
//            }
//        }
//        return "사용자";
//    }
//
//    private String extractProfileUrl(OAuth2User oAuth2User, String provider) {
//        if ("kakao".equals(provider)) {
//            Map<String, Object> properties = oAuth2User.getAttribute("properties");
//            if (properties != null) {
//                return (String) properties.get("profile_image_url");
//            }
//        }
//        return null;
//    }
//
//    private void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
//        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie(name, value);
//        cookie.setHttpOnly(true);
//        cookie.setPath("/");
//        cookie.setMaxAge(maxAge);
//        response.addCookie(cookie);
    }
}