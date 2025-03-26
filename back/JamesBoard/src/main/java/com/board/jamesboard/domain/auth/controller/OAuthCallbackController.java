package com.board.jamesboard.domain.auth.controller;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.error.ErrorResponse;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.domain.auth.dto.RefreshTokenResponseDto;
import com.board.jamesboard.domain.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class OAuthCallbackController {

    private final AuthService authService;

    @Operation(summary = "카카오 OAuth 콜백 처리", description = "카카오 로그인 후 리다이렉트되는 콜백 처리" )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "카카오 로그인 성공",
                content = @Content(schema = @Schema(implementation = RefreshTokenResponseDto.class))),
            @ApiResponse(responseCode = "400", description = "인가 코드가 유효하지 않습니다 ( 카카오 인가 코드가 잘못되었거나 만료된 경우)",
                content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (카카오 서버에서 인증 거부시)",
                content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "500", description = "서버 내부 오류가 발생했습니다. 다시 시도해주세요. (서버 오류 발생시)",
                content = @Content(schema = @Schema(implementation = ErrorResponse.class)))
    })
    @GetMapping("/login/oauth2/code/kakao")
    public ResponseEntity<?> processKakaoLogin(@Parameter(description = "카카오 인가 코드", required = true) @RequestParam String code) {
        log.info("========== OAuthCallbackController 시작: 카카오 인가 코드 = {} ==========", code);

        try {
            // 로직 실행 전 로그
            log.info("AuthService.processKakaoLogin 호출 전");
            log.info("카카오 인가 코드: {}", code);

            RefreshTokenResponseDto response = authService.processKakaoLogin(code);
            log.info("카카오 로그인 성공 {}", response.getUserId());
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("카카오 로그인 처리 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode()));
        } catch (Exception e) {
            log.error("카카오 로그인 처리 중 예상치 못한 오류 발생 {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ErrorResponse(ErrorCode.INTERNAL_SERVER_ERROR));
        }
    }

}
