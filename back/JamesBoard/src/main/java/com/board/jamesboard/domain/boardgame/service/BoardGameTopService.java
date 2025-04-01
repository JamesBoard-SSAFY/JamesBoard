package com.board.jamesboard.domain.boardgame.service;

import java.util.List;

import com.board.jamesboard.domain.boardgame.dto.BoardGameTopResponseDto;

public interface BoardGameTopService {
    List<BoardGameTopResponseDto> getBoardGameTop(String sortBy, Integer limit);
}