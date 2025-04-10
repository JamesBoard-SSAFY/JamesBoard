package com.board.jamesboard.core.auth.handler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Slf4j
@Component
public class OAuthLoginFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {
//        log.error("OAuth 로그인 실패: {}", exception.getMessage());
//        log.error("오류 클래스 : {}", exception.getClass().getName());
//        log.error("상세 오류:", exception);
//
//        // 안전한 URL 인코딩 적용
//        String encodedErrorMessage = URLEncoder.encode(exception.getMessage(), StandardCharsets.UTF_8.toString());
//
//        // 에러 정보를 포함하여 리다이렉트
//        getRedirectStrategy().sendRedirect(request, response,
//                "/login/oauth2/error?error=" + encodedErrorMessage);
    }
}