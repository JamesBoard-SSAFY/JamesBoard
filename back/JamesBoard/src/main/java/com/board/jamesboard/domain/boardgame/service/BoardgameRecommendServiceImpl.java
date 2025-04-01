package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.Recommend;
import com.board.jamesboard.db.entity.RecommendContent;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.RecommendContentRepository;
import com.board.jamesboard.db.repository.RecommendRepository;
import com.board.jamesboard.db.repository.UserActivityRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.db.repository.GameThemeRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardGameRecommendResponseDto;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class BoardgameRecommendServiceImpl implements BoardGameRecommendService {

    private final UserRepository userRepository;
    private final RecommendContentRepository recommendContentRepository;
    private final RecommendRepository recommendRepository;
    private final UserActivityRepository userActivityRepository;
    private final GameThemeRepository gameThemeRepository;

    @Override
    public List<BoardGameRecommendResponseDto> getBoardGameRecommends(Long userId, Integer limit) {
        // 사용자와 선호 게임 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("user_id를 찾지 못했습니다"));
        
        Game preferGame = user.getPreferGame();
        if (preferGame == null) {
            throw new RuntimeException("온보딩 값이 없거나 선호게임이 없는 유저입니다.");
        }

        // 사용자가 남긴 전체 리뷰 수 조회
        List<Game> userGames = userActivityRepository.findDistinctGameByUserUserId(userId);
        int totalReviewCount = userGames.size();

        if (totalReviewCount < 30) {
            // 콘텐츠 기반 추천
            List<RecommendContent> recommendContents = recommendContentRepository
                    .findTopNByGameOrderByRecommendContentRankAsc(preferGame, limit);

            return recommendContents.stream()
                    .map(rc -> {
                        Game recommendGame = rc.getRecommendGame();
                        List<String> themes = gameThemeRepository.findThemeByGameId(recommendGame.getGameId());
                        return new BoardGameRecommendResponseDto(
                                recommendGame.getGameId(),
                                recommendGame.getGameTitle(),
                                recommendGame.getGameImage(),
                                recommendGame.getGameCategories().isEmpty() ? null : recommendGame.getGameCategories().get(0).getGameCategoryName(),
                                themes.isEmpty() ? null : themes.get(0),
                                recommendGame.getMinPlayer(),
                                recommendGame.getMaxPlayer(),
                                recommendGame.getGameDifficulty(),
                                recommendGame.getGamePlayTime(),
                                recommendGame.getGameDescription()
                        );
                    })
                    .collect(Collectors.toList());
        } else {
            // 하이브리드 추천
            List<Recommend> recommends = recommendRepository
                    .findTopNByUserOrderByRecommendRankAsc(user, limit);

            return recommends.stream()
                    .map(recommend -> {
                        Game recommendGame = recommend.getGame();
                        List<String> themes = gameThemeRepository.findThemeByGameId(recommendGame.getGameId());
                        return new BoardGameRecommendResponseDto(
                                recommendGame.getGameId(),
                                recommendGame.getGameTitle(),
                                recommendGame.getGameImage(),
                                recommendGame.getGameCategories().isEmpty() ? null : recommendGame.getGameCategories().get(0).getGameCategoryName(),
                                themes.isEmpty() ? null : themes.get(0),
                                recommendGame.getMinPlayer(),
                                recommendGame.getMaxPlayer(),
                                recommendGame.getGameDifficulty(),
                                recommendGame.getGamePlayTime(),
                                recommendGame.getGameDescription()
                        );
                    })
                    .collect(Collectors.toList());
        }
    }
} 
