package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardgameRecommendDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class BoardgameSearchServiceImpl implements BoardgameSearchService {

    private final GameRepository gameRepository;

    @Override
    public List<BoardgameRecommendDto> searchBoardgames(Integer difficulty, Integer minPlayers, String name, String category) {
        // N+1 방지용 fetch join 사용된 메서드
        List<Game> games = gameRepository.findAllWithCategories();

        log.debug("{} games found", games.size());

        return games.stream()
                .filter(game -> difficulty == null || game.getGameDifficulty().equals(difficulty))
                .filter(game -> minPlayers == null || game.getMinPlayer() >= minPlayers)
                .filter(game -> name == null || game.getGameTitle().contains(name))
                .filter(game -> category == null ||
                        (game.getGameCategories() != null &&
                                game.getGameCategories().stream()
                                        .anyMatch(c -> c.getGameCategoryName().equalsIgnoreCase(category))))
                .map(game -> new BoardgameRecommendDto(
                        game.getGameId(),
                        game.getGameTitle(),
                        game.getGameImage(),
                        game.getGameCategories().isEmpty() ? null : game.getGameCategories().get(0).getGameCategoryName(),
                        game.getGameThemes().isEmpty() ? null : game.getGameThemes().get(0).getGameThemeName(),
                        game.getMinPlayer(),
                        game.getMaxPlayer(),
                        game.getGameDifficulty(),
                        game.getGamePlayTime(),
                        game.getGameDescription()
                ))
                .collect(Collectors.toList());
    }
}
