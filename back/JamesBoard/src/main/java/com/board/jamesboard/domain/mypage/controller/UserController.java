package com.board.jamesboard.domain.mypage.controller;

import com.amazonaws.Response;
import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.error.ErrorResponse;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.domain.auth.controller.AuthController;
import com.board.jamesboard.domain.mypage.dto.*;
import com.board.jamesboard.domain.mypage.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Tag(name = "Mypage", description = "마이페이지 API")
@SecurityRequirement(name = "bearer-jwt")
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @Operation(summary = "사용자 정보 조회", description = "사용자의 프로필 정보를 조회")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "사용자 정보 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserProfileResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)"),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)")
    })
    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserProfile(@PathVariable Long userId) {
        try {
            // JWT 토큰에서 사용자 ID 추출
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Long currentUserId = Long.parseLong(authentication.getName());

            // 요청 userId와 토큰 userId 일치 여부 확인
            if (!userId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse(HttpStatus.FORBIDDEN, "접근 권한이 없습니다"));
            }

            // 내 정보 조회
            UserProfileResponseDto response = userService.getUserProfile(userId);
            return ResponseEntity.ok(response);

        } catch (CustomException e) {
            log.error("사용자 정보 조회 실패 : {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage()));
        } catch (Exception e) {
            log.error("사용자 정보 조회 중 오류 발생 : {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(HttpStatus.UNAUTHORIZED, "인증되지 않은 요청입니다"));
        }

    }

    @Operation(summary = "사용자 프로필 수정", description = "사용자의 프로필 정보를 수정합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "프로필 수정 성공",
                    content = @Content(schema = @Schema(implementation = UserProfileUpdateResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)"),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)"),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)"),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.")
    })
    @PatchMapping("/{userId}")
    public ResponseEntity<?> updateUserProfile(@PathVariable Long userId, @RequestBody UserProfileUpdateRequestDto request) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Long currentUserId = Long.parseLong(authentication.getName());

            // 일치 여부
            if (!userId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse(HttpStatus.FORBIDDEN, "접근 권한이 없습니다"));
            }

            // 프로필 정보 수정
            UserProfileUpdateResponseDto response = userService.updateUserProfile(userId, request);
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("사용자 프로필 수정 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage()));
        } catch (Exception e) {
            log.error("사용자 프로필 수정 중 오류 발생 : {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(HttpStatus.UNAUTHORIZED, "인증되지 않은 요청입니다)"));
        }

    }
    @Operation(summary = "사용자 플레이 게임 목록 조회", description = "사용자가 플레이한 게임 목록을 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "게임 목록 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserGameResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)"),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)"),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)"),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.")
    })
    @GetMapping("/{userId}/archives/games")
    public ResponseEntity<?> getUserGames(@PathVariable Long userId) {
        try {
            // 사용자 ID 추출
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Long currentUserId = Long.parseLong(authentication.getName());

            // 일치 여부
            if (!userId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse(HttpStatus.FORBIDDEN, "접근 권한이 없습니다"));
            }

            // 사용자 플레이 게임 목록 조회
            List<UserGameResponseDto> response = userService.getUserGames(userId);
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("사용자 게임 목록 조회 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage()));
        } catch (Exception e) {
            log.error("사용자 게임 목록 조회 중 오류 발생 : {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(HttpStatus.UNAUTHORIZED, "인증되지 않은 요청입니다"));
        }


    }

    @Operation(summary = "사용자의 특정 게임 아카이브 조회", description = "사용자가 특정 게임에 대해 작성한 아카이브 목록과 게임 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "아카이브 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserProfileResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)"),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)"),
            @ApiResponse(responseCode = "404", description = "해당 게임을 찾을 수 없습니다."),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.")
    })
    @GetMapping("/{userId}/archives")
    public ResponseEntity<?> getUserGameArchives(
            @PathVariable Long userId,
            @Parameter(description = "게임 ID", required = true, example = "1")
            @RequestParam Long gameId) {
        try {
            // 사용자 ID 추출
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Long currentUserId = Long.parseLong(authentication.getName());

            // 일치 여부
            if (!userId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse(HttpStatus.FORBIDDEN, "접근 권한이 없습니다"));
            }

            UserGameArchiveResponseDto response = userService.getUserGameArchive(userId, gameId);
            return ResponseEntity.ok(response);
        } catch (CustomException e) {
            log.error("아카이브 조회 실패: {}", e.getMessage());
            return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                    .body(new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage()));
        } catch (Exception e) {
            log.error("아카이브 조회 중 오류 발생: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(HttpStatus.UNAUTHORIZED, "인증되지 않은 요청입니다"));
        }

    }

    @Operation(summary = "사용자의 게임 통계 및 순위 조회", description = "사용자의 보드게임 플레이 통계와 순위 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "통계 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserStatsResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)"),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)"),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)"),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.")
    })
    @GetMapping("/{userId}/statics")
    public ResponseEntity<?> getUserGameStats(@PathVariable Long userId) {
        try {
            // JWT 토큰에서 사용자 ID 추출
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Long currentUserId = Long.parseLong(authentication.getName());

            // 요청된 사용자 ID와 토큰의 사용자 ID 일치 여부 확인
            if (!userId.equals(currentUserId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ErrorResponse(HttpStatus.FORBIDDEN, "접근 권한이 없습니다"));
            }

            // 사용자 통계 및 순위 조회
            UserStatsResponseDto response = userService.getUserGameStats(userId);
            return ResponseEntity.ok(response);

        } catch (CustomException e) {
        log.error("게임 통계 조회 실패 : {}", e.getMessage());
        return ResponseEntity.status(e.getErrorCode().getHttpStatus())
                .body(new ErrorResponse(e.getErrorCode().getHttpStatus(), e.getMessage()));

        } catch (Exception e) {
            log.error("게임 통계 조회 중 오류 발생 : {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ErrorResponse(HttpStatus.UNAUTHORIZED, "인증되지 않은 요청입니다"));
        }
    }

    @GetMapping("/{userId}/prefer-games")
    @Operation(summary = "유저 선호게임 조회(없으면 -1)")
    public ResponseEntity<Long> getUserGamePreferGames(@PathVariable Long userId) {
        return ResponseEntity.ok(userService.getUserPreferGame(userId));
    }

}
