package com.board.jamesboard.core.constant;

import org.springframework.http.HttpStatus;

import lombok.Getter;

@Getter
public enum ErrorCode {
    // 400 BAD_REQUEST
    INVALID_INPUT_VALUE("유효하지 않은 입력값입니다", HttpStatus.BAD_REQUEST),
    INVALID_TOKEN_FORM("유효하지 않은 토큰 형식입니다", HttpStatus.BAD_REQUEST),

    // 401 UNAUTHORIZED
    UNAUTHORIZED("인증되지 않은 요청입니다", HttpStatus.UNAUTHORIZED),
    EXPIRED_ACCESS_TOKEN("액세스 토큰이 만료되었습니다", HttpStatus.UNAUTHORIZED),
    EXPIRED_REFRESH_TOKEN("리프레시 토큰이 만료되었습니다", HttpStatus.UNAUTHORIZED),
    INVALID_REFRESH_TOKEN("유효하지 않은 리프레시 토큰입니다", HttpStatus.UNAUTHORIZED),

    // 404 NOT_FOUND
    USER_NOT_FOUND("해당 유저를 찾을 수 없습니다", HttpStatus.NOT_FOUND),
    GAME_NOT_FOUND("해당 게임을 찾을 수 없습니다", HttpStatus.NOT_FOUND),

    // 500 SERVER_ERROR
    INTERNAL_SERVER_ERROR("서버 오류가 발생했습니다", HttpStatus.INTERNAL_SERVER_ERROR);

    private final String message;

    private final HttpStatus httpStatus;

    ErrorCode(String message, HttpStatus httpStatus) {
        this.message = message;
        this.httpStatus = httpStatus;
    }

}
