package com.board.jamesboard.domain.useractivity.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RatingResponseDto {
    private Long userActivityId;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;
    private Float userActivityRating;
    private Integer userActivityTime;
    private Long gameId;
    private Long userId;
}
