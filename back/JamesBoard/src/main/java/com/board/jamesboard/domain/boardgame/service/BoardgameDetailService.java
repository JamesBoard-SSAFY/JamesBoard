package com.board.jamesboard.domain.boardgame.service;

import com.board.jamesboard.domain.boardgame.dto.BoardgameDetailDto;

public interface BoardgameDetailService {
    BoardgameDetailDto getBoardgameDetail(Long gameId);
}