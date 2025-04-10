package com.board.jamesboard.domain.onboard.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OnBoardResponseDto {
    private Long gameId;
    private String gameTitle;
}
