package com.board.jamesboard.domain.boardgame.service;

import java.util.List;

import com.board.jamesboard.domain.boardgame.dto.BoardgameTopDto;

public interface BoardgameTopService {
    List<BoardgameTopDto> getBoardgameTop(String sortBy, Integer limit);
}