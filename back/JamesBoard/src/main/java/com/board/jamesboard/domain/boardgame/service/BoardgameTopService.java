package com.board.jamesboard.domain.boardgame.service;

import java.util.List;

import com.board.jamesboard.domain.boardgame.dto.BoardgameTopDto;
import com.board.jamesboard.domain.boardgame.dto.BoardgameType;

public interface BoardgameTopService {
    List<BoardgameTopDto> getBoardgameTop(Long userId, Long boardId, BoardgameType boardType, Long page, Integer limit);
}