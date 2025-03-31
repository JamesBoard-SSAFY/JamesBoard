package com.board.jamesboard.domain.boardgame.service;

import java.util.List;

import com.board.jamesboard.domain.boardgame.dto.BoardGameResponseDto;

public interface BoardGameSearchService {
    List<BoardGameResponseDto> searchBoardGames(Integer difficulty, Integer minPlayers, String name, String category);
}