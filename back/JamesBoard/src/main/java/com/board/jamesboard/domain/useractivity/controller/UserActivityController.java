package com.board.jamesboard.domain.useractivity.controller;

import com.board.jamesboard.domain.useractivity.dto.RatingRequestDto;
import com.board.jamesboard.domain.useractivity.dto.UserActivityResponseDto;
import com.board.jamesboard.domain.useractivity.service.UserActivityService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-activity")
@CrossOrigin("*")
@RequiredArgsConstructor
@Slf4j
public class UserActivityController {
    private final UserActivityService userActivityService;

    @GetMapping("")
    @Operation(summary = "게임ID와 유저ID 조합에 해당하는 유저 활동 조회")
    public ResponseEntity<List<UserActivityResponseDto>> getUserActivity(@RequestParam Long userId, @RequestParam Long gameId) {
        return ResponseEntity.ok(userActivityService.getUserActivity(userId, gameId));
    }

    @PostMapping("")
    @Operation(summary = "유저 활동에 평점 추가")
    public ResponseEntity<Long> createUserRating(@RequestBody RatingRequestDto ratingRequestDto) {
        return ResponseEntity.ok(userActivityService.createUserActivityRating(ratingRequestDto));
    }

}
