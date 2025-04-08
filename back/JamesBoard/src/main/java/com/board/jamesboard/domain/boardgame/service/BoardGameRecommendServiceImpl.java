package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import com.board.jamesboard.db.entity.*;
import com.board.jamesboard.db.repository.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import com.board.jamesboard.domain.boardgame.dto.BoardGameRecommendResponseDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class BoardGameRecommendServiceImpl implements BoardGameRecommendService {

    private final UserRepository userRepository;
    private final RecommendContentRepository recommendContentRepository;
    private final RecommendRepository recommendRepository;
    private final UserActivityRepository userActivityRepository;
    private final GameRepository gameRepository;

    @Override
    public List<BoardGameRecommendResponseDto> getBoardGameRecommends(Long userId, Integer limit) {
        // 사용자와 선호 게임 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("user_id를 찾지 못했습니다"));

        Game preferGame = user.getPreferGame();
        if (preferGame == null) {
            throw new RuntimeException("온보딩 값이 없거나 선호게임이 없는 유저입니다.");
        }

        Long totalReviewCount = userActivityRepository.countByUserUserIdAndUserActivityRatingIsNotNull(userId);

        if (totalReviewCount < 5) {
            // 콘텐츠 기반 추천
            List<RecommendContent> recommendContents = recommendContentRepository
                    .findTopNByGameOrderByRecommendContentRankAsc(preferGame, limit);

            List<Long> recommendGameIds = extractGameIdsFromRecommendContent(recommendContents);
            List<Game> gamesWithThemes = gameRepository.findByGameIdInWithThemes(recommendGameIds);
            Map<Long, List<String>> themeMap = mapThemesByGameId(gamesWithThemes);

            return recommendContents.stream()
                    .map(rc -> toRecommendDto(rc.getRecommendGame(), themeMap))
                    .collect(Collectors.toList());
        } else {
            // 하이브리드 추천
            List<Recommend> recommends = recommendRepository
                    .findTopNByUserOrderByRecommendRankAsc(user, limit);

            List<Long> recommendGameIds = extractGameIdsFromRecommend(recommends);
            List<Game> gamesWithThemes = gameRepository.findByGameIdInWithThemes(recommendGameIds);
            Map<Long, List<String>> themeMap = mapThemesByGameId(gamesWithThemes);

            return recommends.stream()
                    .map(r -> toRecommendDto(r.getGame(), themeMap))
                    .collect(Collectors.toList());
        }
    }

    private List<Long> extractGameIdsFromRecommendContent(List<RecommendContent> contents) {
        return contents.stream()
                .map(rc -> rc.getRecommendGame().getGameId())
                .toList();
    }

    private List<Long> extractGameIdsFromRecommend(List<Recommend> contents) {
        return contents.stream()
                .map(r -> r.getGame().getGameId())
                .toList();
    }

    private Map<Long, List<String>> mapThemesByGameId(List<Game> games) {
        return games.stream()
                .collect(Collectors.toMap(
                        Game::getGameId,
                        g -> g.getGameThemes().stream()
                                .map(GameTheme::getGameThemeName)
                                .toList()
                ));
    }

    private BoardGameRecommendResponseDto toRecommendDto(Game game, Map<Long, List<String>> themeMap) {
        List<String> themes = themeMap.getOrDefault(game.getGameId(), List.of());

        return new BoardGameRecommendResponseDto(
                game.getGameId(),
                game.getGameTitle(),
                game.getGameImage(),
                game.getGameCategories().isEmpty() ? null : game.getGameCategories().get(0).getGameCategoryName(),
                themes.isEmpty() ? null : themes.get(0),
                game.getMinPlayer(),
                game.getMaxPlayer(),
                game.getGameDifficulty(),
                game.getGamePlayTime(),
                game.getGameDescription()
        );
    }

} 
