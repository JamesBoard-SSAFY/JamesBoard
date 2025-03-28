package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardgameRecommendDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class BoardgameSearchServiceImpl implements BoardgameSearchService {

    private final GameRepository gameRepository;

    @Override
    public List<BoardgameRecommendDto> BoardgameSearchService(Integer difficulty, Integer minPlayers, String name, String category) {
        List<Game> games = gameRepository.findAll();
        return games.stream()
                .filter(game -> (difficulty == null || game.getGameDifficulty().equals(difficulty)))
                .filter(game -> (minPlayers == null || game.getMinPlayer() >= minPlayers))
                .filter(game -> (name == null || game.getGameTitle().contains(name)))
                .filter(game -> (category == null || 
                    (game.getGameCategories() != null && !game.getGameCategories().isEmpty() && 
                     game.getGameCategories().get(0).getGameCategoryName().equalsIgnoreCase(category))))
                .map(game -> new BoardgameRecommendDto(
                        game.getGameId(),
                        game.getGameTitle(),
                        game.getGameImage(),
                        game.getGameCategories().isEmpty() ? null : game.getGameCategories().get(0).getGameCategoryName(),
                        game.getMinPlayer(),
                        game.getMaxPlayer(),
                        game.getGameDifficulty(),
                        game.getGamePlayTime(),
                        game.getGameDescription()
                ))
                .collect(Collectors.toList());
    }
}
