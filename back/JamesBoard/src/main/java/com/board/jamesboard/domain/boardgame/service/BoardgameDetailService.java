package com.board.jamesboard.domain.boardgame.service;

import com.board.jamesboard.domain.boardgame.dto.BoardGameDetailResponseDto;

public interface BoardGameDetailService {
    BoardGameDetailResponseDto getBoardGameDetail(Long gameId);
}