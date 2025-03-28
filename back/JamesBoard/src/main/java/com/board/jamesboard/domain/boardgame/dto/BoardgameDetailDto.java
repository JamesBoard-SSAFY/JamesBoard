package com.board.jamesboard.domain.boardgame.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardgameDetailDto {
    private Long gameId;
    private String gameTitle;
    private String gameImage;
    private List<String> gameCategories;
    private List<String> gameThemes;
    private List<String> gameDesigners;
    private String gamePublisher;
    private Integer gameYear;
    private Integer gameMinAge;
    private Integer minPlayers;
    private Integer maxPlayers;
    private Integer difficulty;
    private Integer playTime;
    private String description;
    private Float gameRating;
}
