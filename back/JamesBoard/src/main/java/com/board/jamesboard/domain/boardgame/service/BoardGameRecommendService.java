package com.board.jamesboard.domain.boardgame.service;

import com.board.jamesboard.domain.boardgame.dto.BoardGameRecommendResponseDto;

import java.util.List;

public interface BoardGameRecommendService {
    List<BoardGameRecommendResponseDto> getBoardGameRecommends(Long userId, Integer limit);
}