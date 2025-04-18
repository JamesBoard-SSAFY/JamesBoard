package com.board.jamesboard.domain.boardgame.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardGameSearchResponseDto {
    private Long gameId;
    private String gameTitle;
    private String gameImage;
    private String gameCategory;
    private String gameTheme;
    private Integer minPlayer;
    private Integer maxPlayer;
    private Integer difficulty;
    private Integer playTime;
    private String gameDescription;
}
