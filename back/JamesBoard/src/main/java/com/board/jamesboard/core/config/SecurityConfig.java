package com.board.jamesboard.core.config;

import com.board.jamesboard.core.auth.handler.OAuthLoginFailureHandler;
import com.board.jamesboard.core.auth.handler.OAuthLoginSuccessHandler;
import com.board.jamesboard.core.auth.jwt.JWTFilter;
import com.board.jamesboard.core.auth.jwt.JWTUtil;
import com.board.jamesboard.domain.auth.service.RefreshTokenService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.Collections;
import java.util.List;

@Configuration
public class SecurityConfig {

    private final JWTUtil jwtUtil;
    private final OAuthLoginSuccessHandler oAuthLoginSuccessHandler;
    private final OAuthLoginFailureHandler oAuthLoginFailureHandler;

    public SecurityConfig(JWTUtil jwtUtil,
                          OAuthLoginSuccessHandler oAuthLoginSuccessHandler,
                          OAuthLoginFailureHandler oAuthLoginFailureHandler1) {
        this.jwtUtil = jwtUtil;
        this.oAuthLoginSuccessHandler = oAuthLoginSuccessHandler;
        this.oAuthLoginFailureHandler = oAuthLoginFailureHandler1;
    }

    @Bean
    SecurityFilterChain defaultSecurityFilterChain(HttpSecurity http, RefreshTokenService refreshTokenService) throws Exception {
        http
            .sessionManagement(sessionConfig -> sessionConfig.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            //CORS 설정
            .cors(corsConfig -> corsConfig.configurationSource(new CorsConfigurationSource() {
                @Override
                public CorsConfiguration getCorsConfiguration(HttpServletRequest request) {
                    CorsConfiguration config = new CorsConfiguration();
                    config.setAllowedOriginPatterns(List.of(
                            "http://localhost:8000",
                            "http://localhost:8080",
                            "http://j12d205.p.ssafy.io:9090",
                            "https://j12d205.p.ssafy.io"
                    ));
                    config.setAllowedMethods(Collections.singletonList("*"));
                    config.setAllowedHeaders(Collections.singletonList("*"));
                    config.setMaxAge(3600L);
                    config.setAllowCredentials(true);
                    config.setExposedHeaders(Collections.singletonList("Authorization"));
                    return config;
                }
            }))
            .csrf(AbstractHttpConfigurer::disable)
            //경로별 접근권한
            .authorizeHttpRequests((requests) -> requests
                    .requestMatchers("/login/oauth2/code/**").permitAll()
                    .requestMatchers("/login/oauth2/error").permitAll()
                    .requestMatchers("/api/auth/**").permitAll()
                    .requestMatchers("/error").permitAll()
                    // Swagger UI
                    .requestMatchers("/swagger-ui/**", "/swagger-ui.html").permitAll()
                    .requestMatchers("/swagger-resources/**").permitAll()
                    .requestMatchers("/v3/api-docs", "/v3/api-docs/**").permitAll() // 정확한 경로 추가
                    .requestMatchers("/webjars/**").permitAll() // 웹자 리소스도 추가
                    // 나머지 비허용
                    .anyRequest().authenticated())
            .addFilterBefore(new JWTFilter(jwtUtil, refreshTokenService), UsernamePasswordAuthenticationFilter.class);
//            .oauth2Login(oauth2 -> oauth2
//                    .loginPage("/api/auth/login-oauth")
//                    .successHandler(oAuthLoginSuccessHandler)
//                    .failureHandler(oAuthLoginFailureHandler)
//                    .redirectionEndpoint(endpoint ->
//                            endpoint.baseUri("/login/oauth2/code/*"))
//            );
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories.createDelegatingPasswordEncoder();
    }
}
