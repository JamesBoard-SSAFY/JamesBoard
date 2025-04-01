package com.board.jamesboard.domain.auth.controller;

import com.amazonaws.Response;
import com.board.jamesboard.core.auth.dto.CustomUserDetails;
import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.error.ErrorResponse;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.domain.auth.dto.KakaoTokenRequestDto;
import com.board.jamesboard.domain.auth.dto.RefreshTokenRequestDto;
import com.board.jamesboard.domain.auth.dto.RefreshTokenResponseDto;
import com.board.jamesboard.domain.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.persistence.Table;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@Slf4j
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Auth", description = "인증 API")
public class AuthController {

    @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.kakao.redirect-uri}")
    private String redirectUri;

    private final AuthService authService;

    @Operation(summary = "카카오 로그인 페이지 리다이렉트",
            description = "<b>[설명]</b> 카카오 OAuth 로그인 페이지로 리다이렉트.<br/>" +
                    "<b>[요청]</b> 선택적으로 error 파라미터를 전달할 수 있음.<br/>" +
                    "<b>[응답]</b> 성공시 302 상태 코드와 함께 카카오 로그인 페이지로 리다이렉트.<br/>" +
                    "<b>[권한]</b> 인증이 필요하지 않음.<br/>" +
                    "<b>[오류]</b> 요청 파라미터가 유효하지 않을 시 400 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "302", description = "카카오 로그인 페이지 리다이렉트 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청입니다 (요청 파라미터가 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":400,\"message\":\"잘못된 요청입니다.\"}")))
    })
    @GetMapping("/login-oauth")
    public ResponseEntity<?> kakaoLogin(@Parameter(description = "OAuth 에러 파라미터") @RequestParam(required = false) String error) {

        try {
            // 로그출력부
            if (error != null) {
                log.error("OAuth 로그인 중 오류 발생: {}", error);
                return ResponseEntity.badRequest()
                        .body(new ErrorResponse(ErrorCode.INVALID_INPUT_VALUE));
            }


            //URL 구성
            String kakaoAuthUrl = "https://kauth.kakao.com/oauth/authorize" +
                    "?client_id=" + clientId +
                    "&redirect_uri=" + redirectUri +
                    "&response_type=code";

            // 리다이렉트 응답 반환
            HttpHeaders headers = new HttpHeaders();
            headers.setLocation(URI.create(kakaoAuthUrl));
            return new ResponseEntity<>(headers, HttpStatus.FOUND);
        } catch (Exception e) {
            log.error("카카오 로그인 페이지 리다이렉트 중 오류 발생 : {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "엑세스 토큰 갱신",
            description = "<b>[설명]</b> 리프레시 토큰을 사용하여 엑세스 토큰을 갱신.<br/>" +
                    "<b>[요청]</b> 리프레시 토큰을 request body로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 새로운 엑세스 토큰과 리프레시 토큰, 사용자 정보를 반환.<br/>" +
                    "<b>[권한]</b> 인증이 필요하지 않음.<br/>" +
                    "<b>[오류]</b> 리프레시 토큰이 유효하지 않을 시 401 오류, 사용자가 존재하지 않을 시 404 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "토큰 갱신 성공",
                    content = @Content(schema = @Schema(implementation = RefreshTokenResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 사용자입니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 내부 오류가 발생했습니다. 다시 시도해 주세요. (서버 오류 발생시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 내부 오류가 발생했습니다. 다시 시도해 주세요.\"}")))
    })
    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@Parameter(description = "리프레시 토큰 정보" ) @RequestBody RefreshTokenRequestDto request) {
        try {
            RefreshTokenResponseDto response = authService.refreshToken(request.getRefreshToken());
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("토큰 갱신 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode()));
        } catch (Exception e) {
            log.error("토큰 갱신 중 예상치 못한 오류 발생 {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "로그아웃",
            description = "<b>[설명]</b> 사용자 로그아웃 처리 및 리프레시 토큰 삭제.<br/>" +
                    "<b>[요청]</b> 인증된 사용자의 JWT 토큰을 헤더에 포함하여 요청.<br/>" +
                    "<b>[응답]</b> 성공시 200 상태 코드를 반환.<br/>" +
                    "<b>[권한]</b> 인증된 사용자만 요청 가능.<br/>" +
                    "<b>[오류]</b> 인증 정보가 없거나 유효하지 않을 시 401 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그아웃 성공"),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다 (인증 정보가 없거나 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 내부 오류가 발생했습니다. 다시 시도해 주세요. (서버 오류 발생시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 내부 오류가 발생했습니다. 다시 시도해 주세요.\"}")))
    })
    @SecurityRequirement(name = "bearer-jwt")
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@Parameter(description = "인증된 사용자 정보", hidden = true)
                                        @AuthenticationPrincipal CustomUserDetails userDetails) {
        try {
            // 인증된 사용자가 없으면 401 오류 반환
            if (userDetails == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ErrorResponse(ErrorCode.UNAUTHORIZED));
            }
            // 로그아웃 처리
            authService.logout(userDetails.getUserId());
            return ResponseEntity.ok().build();
        } catch (CustomException e) {
            log.error("로그아웃 처리 실패 {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode()));
        } catch (Exception e) {
            log.error("로그아웃 처리 중 예상치 못한 오류 발생 {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "카카오 토큰 로그인",
            description = "<b>[설명]</b> 카카오 SDK에서 얻은 액세스 토큰으로 로그인.<br/>" +
                    "<b>[요청]</b> 카카오 SDK에서 획득한 액세스 토큰을 request body로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 JWT 액세스 토큰, 리프레시 토큰, 사용자 정보를 반환.<br/>" +
                    "<b>[권한]</b> 인증이 필요하지 않음.<br/>" +
                    "<b>[오류]</b> 토큰이 유효하지 않을 시 400 오류, 카카오 서버 인증 거부 시 401 오류 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "로그인 성공",
                    content = @Content(schema = @Schema(implementation = RefreshTokenResponseDto.class))),
            @ApiResponse(responseCode = "400", description = "잘못된 요청입니다",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":400,\"message\":\"잘못된 요청입니다.\"}"))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 내부 오류가 발생했습니다. 다시 시도해 주세요.",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 내부 오류가 발생했습니다. 다시 시도해 주세요.\"}")))
    })
    @PostMapping("/kakao-token")
    public ResponseEntity<?> processKakaoToken(@RequestBody KakaoTokenRequestDto request) {
        try {
            if (request.getKakaoAccessToken() == null || request.getKakaoAccessToken().isEmpty()) {
                log.error("카카오 엑세스 토큰이 비어있습니다");
                return ResponseEntity.badRequest()
                        .body(new ErrorResponse(ErrorCode.INVALID_INPUT_VALUE));
            }

            RefreshTokenResponseDto response = authService.processKakaoTokenLogin(request.getKakaoAccessToken());
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("카카오 토큰 로그인 처리 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode()));
        } catch (Exception e) {
            log.error("카카오 토큰 로그인 중 예상치 못한 오류 발생 {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR));
        }

    }

//    @GetMapping("/login/oauth2/code/kakao")
//    public ResponseEntity<TokenResponseDto> processKakaoLogin(@RequestParam String code) {
//        log.info("카카오 인가 코드: {}", code);
//        try {
//            TokenResponseDto response = authService.processKakaoLogin(code);
//            log.info("카카오 로그인 성공 {}", response.getUserId());
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            log.error("카카오 로그인 처리 중 오류 발생 {}", e.getMessage(), e);
//            throw e;
//        }
//    }


//    // 로그인 콜백 api
//    @GetMapping("/oauth2/code/kakao")
//    public ResponseEntity<TokenResponseDto> kakaoCallback(@RequestParam String code) {
//        log.info("카카오 인가 코드: {}", code);
//        TokenResponseDto response = authService.processKakaoLogin(code);
//        return ResponseEntity.ok(response);
//    }

}
