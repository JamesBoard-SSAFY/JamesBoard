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
import io.swagger.v3.oas.annotations.media.ExampleObject;
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

    @Operation(summary = "사용자 정보 조회",
            description = "<b>[설명]</b> 사용자의 프로필 정보를 조회.<br/>" +
                    "<b>[요청]</b> 사용자 ID를 {Path Variable}로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 사용자의 프로필 이미지 URL과 닉네임 정보를 반환함.<br/>" +
                    "<b>[권한]</b> 본인의 정보만 조회 가능.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 사용자 ID 요청 시 404 오류 발생")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "사용자 정보 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserProfileResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":403,\"message\":\"접근 권한이 없습니다.\"}"))),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}")))
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

    @Operation(summary = "사용자 프로필 수정",
            description = "<b>[설명]</b> 사용자의 프로필 정보(이미지 URL, 닉네임)를 수정.<br/>" +
                    "<b>[요청]</b> 사용자 ID와 수정할 프로필 정보를 전달.<br/>" +
                    "<b>[응답]</b> 성공시 수정된 사용자 ID를 반환.<br/>" +
                    "<b>[권한]</b> 본인의 정보만 수정 가능.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 사용자 ID 요청 시 404 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "프로필 수정 성공",
                    content = @Content(schema = @Schema(implementation = UserProfileUpdateResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":403,\"message\":\"접근 권한이 없습니다.\"}"))),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 오류가 발생했습니다.\"}")))
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
    @Operation(summary = "사용자 플레이 게임 목록 조회",
            description = "<b>[설명]</b> 사용자가 아카이브를 작성한 게임 목록을 조회함.<br/>" +
                    "<b>[요청]</b> 사용자 ID를 {Path Variable}로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 게임 ID와 이미지 URL이 포함된 게임 목록을 반환.<br/>" +
                    "<b>[권한]</b> 본인의 정보만 조회 가능.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 사용자 ID 요청 시 404 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "게임 목록 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserGameResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":403,\"message\":\"접근 권한이 없습니다.\"}"))),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 오류가 발생했습니다.\"}")))
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

    @Operation(summary = "사용자의 특정 게임 아카이브 조회",
            description = "<b>[설명]</b> 사용자가 특정 게임에 대해 작성한 아카이브 목록과 게임 정보를 조회.<br/>" +
                    "<b>[요청]</b> 사용자 ID와 게임 ID를 전달.<br/>" +
                    "<b>[응답]</b> 성공시 게임 정보(제목, 이미지, 카테고리, 최소/최대 인원, 난이도, 플레이 시간, 최소 연령, 출시 연도)와 작성한 아카이브 목록등이 반환됨.<br/>" +
                    "<b>[권한]</b> 본인의 정보만 조회 가능.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 게임 ID 요청 시 500 오류발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "아카이브 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserGameArchiveResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":403,\"message\":\"접근 권한이 없습니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다. (해당 게임을 찾을 수 없거나 기타 오류)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 오류가 발생했습니다.\"}")))
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

    @Operation(summary = "사용자의 게임 통계 및 순위 조회",
            description = "<b>[설명]</b> 사용자의 보드게임 플레이 통계와 순위 정보를 조회.<br/>" +
                    "<b>[요청]</b> 사용자 ID를 경로 변수로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 총 플레이 횟수, 카테고리별 통계(게임 수, 비율), 가장 많이 플레이한 게임 목록등을 반환.<br/>" +
                    "<b>[권한]</b> 본인의 정보만 조회 가능.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 사용자 ID 요청 시 404 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "통계 조회 성공",
                    content = @Content(schema = @Schema(implementation = UserStatsResponseDto.class))),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청입니다. (JWT 토큰 누락 또는 유효하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":401,\"message\":\"인증되지 않은 요청입니다.\"}"))),
            @ApiResponse(responseCode = "403", description = "접근 권한이 없습니다. (요청된 사용자 ID와 토큰의 사용자 ID가 일치하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":403,\"message\":\"접근 권한이 없습니다.\"}"))),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}"))),
            @ApiResponse(responseCode = "500", description = "서버 오류가 발생했습니다.",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":500,\"message\":\"서버 오류가 발생했습니다.\"}")))
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

    @Operation(summary = "유저 선호게임 조회",
            description = "<b>[설명]</b> 사용자가 선호하는 게임의 ID를 조회.<br/>" +
                    "<b>[요청]</b> 사용자 ID를 {Path Variable}로 전달.<br/>" +
                    "<b>[응답]</b> 성공시 선호 게임 ID를 반환하고, 선호 게임이 없는 경우 -1을 반환.<br/>" +
                    "<b>[권한]</b> 별도의 권한 검사는 존재하지 않음.<br/>" +
                    "<b>[오류]</b> 존재하지 않는 사용자 ID 요청 시 404 오류가 발생.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "선호 게임 조회 성공"),
            @ApiResponse(responseCode = "404", description = "해당 유저를 찾을 수 없습니다. (회원 ID가 존재하지 않을 시)",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class),
                            examples = @ExampleObject(value = "{\"status\":404,\"message\":\"해당 유저를 찾을 수 없습니다.\"}")))
    })
    @GetMapping("/{userId}/prefer-games")
    public ResponseEntity<Long> getUserGamePreferGames(@PathVariable Long userId) {
        return ResponseEntity.ok(userService.getUserPreferGame(userId));
    }

}
