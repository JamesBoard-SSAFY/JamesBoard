package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.QGame;
import com.board.jamesboard.db.entity.QGameCategory;
import com.board.jamesboard.db.entity.QGameTheme;
import com.querydsl.core.group.GroupBy;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
public class GameRepositoryCustomImpl implements GameRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    QGame game = QGame.game;
    QGameCategory categoryAlias = QGameCategory.gameCategory;

    public List<Game> searchGamesWithCategoryOnly(Integer difficulty, Integer minPlayers, String name, String category) {
        QGame game = QGame.game;
        QGameCategory gameCategory = QGameCategory.gameCategory;

        return queryFactory
                .selectFrom(game)
                .leftJoin(game.gameCategories, gameCategory).fetchJoin()
                .where(
                        difficulty != null ? game.gameDifficulty.eq(difficulty) : null,
                        minPlayers != null ? game.minPlayer.goe(minPlayers) : null,
                        name != null ? game.gameTitle.containsIgnoreCase(name) : null,
                        category != null ? gameCategory.gameCategoryName.equalsIgnoreCase(category) : null
                )
                .fetch();
    }
}
