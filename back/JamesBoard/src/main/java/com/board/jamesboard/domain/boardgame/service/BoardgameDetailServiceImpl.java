package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardgameDetailDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BoardgameDetailServiceImpl implements BoardgameDetailService {

    private final GameRepository gameRepository;

    @Override
    public BoardgameDetailDto getBoardgameDetail(Long gameId) {
        // 게임 정보 조회
        Game game = gameRepository.findByGameId(gameId)
                .orElseThrow(() -> new CustomException(ErrorCode.GAME_NOT_FOUND));

        // 카테고리, 테마, 디자이너 정보를 리스트로 변환
        List<String> categories = game.getGameCategories().stream()
                .map(category -> category.getGameCategoryName())
                .collect(Collectors.toList());

        List<String> themes = game.getGameThemes().stream()
                .map(theme -> theme.getGameThemeName())
                .collect(Collectors.toList());

        List<String> designers = game.getGameDesigners().stream()
                .map(designer -> designer.getGameDesignerName())
                .collect(Collectors.toList());

        // DTO 생성 및 반환
        return new BoardgameDetailDto(
                game.getGameId(),
                game.getGameTitle(),
                game.getGameImage(),
                categories,
                themes,
                designers,
                game.getGamePublisher(),
                game.getGameYear(),
                game.getGameMinAge(),
                game.getMinPlayer(),
                game.getMaxPlayer(),
                game.getGameDifficulty(),
                game.getGamePlayTime(),
                game.getGameDescription(),
                game.getGameAvgRating()
        );
    }
} 