package com.board.jamesboard.domain.boardgame.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BoardgameTopDto {
    private Long gameId;
    private String gameImage;
}
