package com.board.jamesboard.domain.boardgame.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardGameResponseDto {
    private Long gameId;
    private String gameTitle;
    private String gameImage;
    private List<String> gameCategory;
    private List<String> gameTheme;
    private Integer minPlayer;
    private Integer maxPlayer;
    private Integer difficulty;
    private Integer playTime;
    private String gameDescription;
}
