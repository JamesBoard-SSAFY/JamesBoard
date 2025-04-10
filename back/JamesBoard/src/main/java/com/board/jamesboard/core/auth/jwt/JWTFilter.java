package com.board.jamesboard.core.auth.jwt;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.auth.dto.CustomUserDetails;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.core.error.ErrorResponse;
import com.board.jamesboard.domain.auth.service.RefreshTokenService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@RequiredArgsConstructor
@Slf4j
public class JWTFilter extends OncePerRequestFilter {

    private final JWTUtil jwtUtil;
    private final RefreshTokenService refreshTokenService;
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected  void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
        throws ServletException, IOException {

        try {
            // 토큰 쿠키 추출
            String refreshToken = extractRefreshTokenFromCookie(request);

            try {
                // jwt 토큰 추출
                String accessToken = jwtUtil.getJwtFromRequest(request);

                //만료 여부 확인
                if (jwtUtil.isExpired(accessToken)) {
                    if (refreshToken != null) {
                        // 리프레쉬 토큰으로 새 토큰 발급
                        JWTToken newToken = refreshTokenService.refreshToken(refreshToken);

                        response.setHeader("Authorization", "Bearer " + newToken.getAccessToken());

                        addRefreshTokenCookie(response, newToken.getRefreshToken());

                        setAuthentication(newToken.getAccessToken());

                    }else {
                        throw new CustomException(ErrorCode.EXPIRED_ACCESS_TOKEN);
                    }
                } else {
                    // 액세스 토큰 유효할 경우
                    setAuthentication(accessToken);
                }
            } catch (CustomException e) {
                // 액세스 토큰이 없거나 형식이 잘못된 경우
                if (refreshToken != null) {
                    try {
                        // 새 토큰 발급 시도
                        JWTToken newToken = refreshTokenService.refreshToken(refreshToken);

                        response.setHeader("Authorization", "Bearer " + newToken.getAccessToken());

                        addRefreshTokenCookie(response, newToken.getRefreshToken());

                        setAuthentication(newToken.getAccessToken());

                    } catch (Exception refreshError) {
                        // 리프레쉬 토큰도 유효 하지 않음
                        setErrorResponse(response, e);
                        return;
                    }
                }else {
                    // 리프레시 토큰 x
                    setErrorResponse(response, e);
                    return;
                }
            }

            filterChain.doFilter(request, response);

        } catch (Exception e) {
            setErrorResponse(response, new CustomException(ErrorCode.UNAUTHORIZED));
        }
    }

    private void setAuthentication(String token) {
        Long userId = jwtUtil.getUserId(token);
        CustomUserDetails userDetails = new CustomUserDetails(userId);
        Authentication authToken = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authToken);
    }
    // 리프레쉬 토큰 추출
    private String extractRefreshTokenFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("refreshToken".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    private void addRefreshTokenCookie(HttpServletResponse response, String refreshToken) {

        Cookie cookie = new Cookie("refreshToken", refreshToken);

        // js 접근 불가 (차후 추가 설정 필요)
        cookie.setHttpOnly(true);

        cookie.setPath("/");

        //https 에서만 쿠키전송
//        cookie.setSecure(true);
        // 쿠키 만료 시간 (7일)
        cookie.setMaxAge(60 * 60 * 24 * 7);

        // 응답에 쿠키 추가
        response.addCookie(cookie);


    }

    // 필터 적용 여부
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        if ("/api/auth/logout".equals(path)) {
            return false;
        }
        // 제외 경로
        return path.startsWith("/api/auth/") ||
                path.startsWith("/swagger-ui/") ||
                path.startsWith("/v3/api-docs") ||
                path.equals("/v3/api-docs") ||
                path.startsWith("/swagger-resources/") ||
                path.startsWith("/webjars/") ||
                path.startsWith("/login/oauth2/code/");
    }

    private void setErrorResponse(HttpServletResponse response, CustomException e) throws IOException {
        // 오류 응답 객체 생성
        ErrorResponse error = new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage());

        // 응답 설정
        response.setStatus(e.getErrorCode().getHttpStatus().value());
        response.setContentType("application/json;charset=UTF-8");

        response.getWriter().write(objectMapper.writeValueAsString(error));

    }

}
