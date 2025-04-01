package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardGameTopResponseDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardGameTopServiceImpl implements BoardGameTopService {

    private final GameRepository gameRepository;

    @Override
    public List<BoardGameTopResponseDto> getBoardGameTop(String sortBy, Integer limit) {
        // 기본값 설정
        if (limit == null || limit <= 0) {
            limit = 9;
        }

        List<Game> games;
        if ("game_rank".equals(sortBy)) {
            // 게임 순위로 정렬
            games = gameRepository.findTopGamesByRank(limit);
        } else if ("game_avg_rating".equals(sortBy)) {
            // 평균 평점으로 정렬
            games = gameRepository.findTopGamesByRating(limit);
        } else {
            // 기본값은 게임 순위로 정렬
            games = gameRepository.findTopGamesByRank(limit);
        }

        // DTO로 변환
        return games.stream()
                .map(game -> new BoardGameTopResponseDto(
                    game.getGameId(),
                    game.getBigThumbnail()
                ))
                .collect(Collectors.toList());
    }
}
