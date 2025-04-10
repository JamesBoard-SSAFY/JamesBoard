package com.board.jamesboard.core.error;

import com.board.jamesboard.core.constant.ErrorCode;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ErrorResponse {

    // 상태코드
    private final int status;

    // 에러 메시지
    private final String message;

    public ErrorResponse(ErrorCode errorCode) {
        this.status = errorCode.getHttpStatus().value();
        this.message = errorCode.getMessage();
    }

    public ErrorResponse(HttpStatus status, String message) {
        this.status = status.value();
        this.message = message;
    }
}
