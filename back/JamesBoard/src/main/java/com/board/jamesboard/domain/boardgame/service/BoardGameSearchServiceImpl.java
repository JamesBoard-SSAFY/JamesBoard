package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.board.jamesboard.db.entity.GameCategory;
import com.board.jamesboard.db.entity.GameTheme;
import com.board.jamesboard.domain.boardgame.dto.BoardGameResponseDto;
import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.repository.GameRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class BoardGameSearchServiceImpl implements BoardGameSearchService {

    private final GameRepository gameRepository;

    @Override
    public List<BoardGameResponseDto> searchBoardGames(Integer difficulty, Integer minPlayers, String name, String category, Integer minPlayTime, Integer maxPlayTime) {

//        List<Game> gamesWithFilter = gameRepository.searchGamesWithCategoryOnly(difficulty, minPlayers, name, category);
//        List<Long> gameIds = gamesWithFilter.stream().map(Game::getGameId).toList();
//        List<Game> gamesWithTheme = gameRepository.findGamesByGameIdsWithThemes(gameIds);
//        List<Game> gameWithCategory = gameRepository.findGamesByGameIdsWithCategories(gameIds);

        List<Long> gameIdsFiltered = gameRepository.findFilteredGameIds(difficulty, minPlayers, name, category, minPlayTime, maxPlayTime);

        List<Game> gamesWithTheme = gameRepository.findGamesByGameIdsWithThemes(gameIdsFiltered);
        List<Game> gameWithCategory = gameRepository.findGamesByGameIdsWithCategories(gameIdsFiltered);

        // Theme 데이터: gameId → themeName 리스트 맵핑
        Map<Long, List<String>> themeMap = gamesWithTheme.stream()
                .collect(Collectors.toMap(
                        Game::getGameId,
                        g -> g.getGameThemes().stream()
                                .map(GameTheme::getGameThemeName)
                                .toList()
                ));

        Map<Long, List<String>> categoryMap = gameWithCategory.stream()
                .collect(Collectors.toMap(
                        Game::getGameId,
                        g -> g.getGameCategories().stream()
                                .map(GameCategory::getGameCategoryName)
                                .toList()
                ));

        // Dto 매핑
        return gameWithCategory.stream()
                .map(game -> new BoardGameResponseDto(
                        game.getGameId(),
                        game.getGameTitle(),
                        game.getSmallThumbnail(),
                        categoryMap.getOrDefault(game.getGameId(), List.of()),
                        themeMap.getOrDefault(game.getGameId(), List.of()),  // 없는 경우 빈 리스트
                        game.getMinPlayer(),
                        game.getMaxPlayer(),
                        game.getGameDifficulty(),
                        game.getGamePlayTime(),
                        game.getGameDescription()
                ))
                .collect(Collectors.toList());

    }
}
