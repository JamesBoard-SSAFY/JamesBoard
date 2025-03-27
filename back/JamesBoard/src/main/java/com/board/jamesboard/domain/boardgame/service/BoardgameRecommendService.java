package com.board.jamesboard.domain.boardgame.service;

import com.board.jamesboard.domain.boardgame.dto.BoardgameRecommendDto;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface BoardgameRecommendService {
    List<BoardgameRecommendDto> getBoardgameRecommends(Long userId, Integer limit);
}