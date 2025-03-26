package com.board.jamesboard;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.time.LocalDateTime;
import java.util.TimeZone;

@Slf4j
@SpringBootApplication
public class JamesBoardApplication {

    public static void main(String[] args) {

        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
        log.info("----- 서버시간 : {} -----", LocalDateTime.now());
        SpringApplication.run(JamesBoardApplication.class, args);
    }

}
