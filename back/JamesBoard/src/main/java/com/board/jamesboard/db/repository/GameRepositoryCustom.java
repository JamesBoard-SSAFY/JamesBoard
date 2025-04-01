package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Game;

import java.util.List;

public interface GameRepositoryCustom {
    List<Game> searchGamesWithCategoryOnly(Integer difficulty, Integer minPlayers, String name, String category);
}
