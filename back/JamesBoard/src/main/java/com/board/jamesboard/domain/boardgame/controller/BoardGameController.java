package com.board.jamesboard.domain.boardgame.controller;

import java.util.List;

import com.board.jamesboard.domain.boardgame.dto.BoardGameResponseDto;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.board.jamesboard.domain.boardgame.dto.BoardGameDetailResponseDto;
import com.board.jamesboard.domain.boardgame.dto.BoardGameRecommendResponseDto;
import com.board.jamesboard.domain.boardgame.dto.BoardGameTopResponseDto;
import com.board.jamesboard.domain.boardgame.service.BoardGameDetailService;
import com.board.jamesboard.domain.boardgame.service.BoardGameRecommendService;
import com.board.jamesboard.domain.boardgame.service.BoardGameSearchService;
import com.board.jamesboard.domain.boardgame.service.BoardGameTopService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Tag(name = "Boardgame", description = "보드게임 API")
@SecurityRequirement(name = "bearer-jwt")
@RequestMapping("/api/games")
@CrossOrigin("*")
@RestController
@RequiredArgsConstructor
public class BoardGameController {

    private final BoardGameRecommendService boardgameRecommendService;
    private final BoardGameSearchService boardgameSearchService;
    private final BoardGameTopService boardgameTopService;
    private final BoardGameDetailService boardgameDetailService;


    @GetMapping("/recommendations")
    @Operation(summary = "추천 보드게임 조회", description = "default 10으로 설정")
    public ResponseEntity<List<BoardGameRecommendResponseDto>> getBoardgameRecommendation(@RequestParam(defaultValue = "10") Integer limit) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long userId = Long.parseLong(authentication.getName());
        
        List<BoardGameRecommendResponseDto> recommendations = boardgameRecommendService.getBoardGameRecommends(userId, limit);
        return ResponseEntity.ok(recommendations);
    }

    @GetMapping("")
    @Operation(summary = "보드게임 조회(검색)", description = "난이도, 최소유저, 보드게임 이름, 카테고리로 구별")
    public ResponseEntity<List<BoardGameResponseDto>> searchBoardgame(
            @RequestParam(required = false) Integer difficulty,
            @RequestParam(required = false) Integer minPlayers,
            @RequestParam(required = false) String boardgameName,
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(boardgameSearchService.searchBoardGames(difficulty, minPlayers, boardgameName, category));
    }

    @GetMapping("/top")
    @Operation(summary = "상위 N개의 게임 조회", description = "bdg는 game_rank, jamesboard는 game_avg_rating입력 (반환 기본값은 9)")
    public ResponseEntity<List<BoardGameTopResponseDto>> getTopBoardgame(
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "9") Integer limit) {
        return ResponseEntity.ok(boardgameTopService.getBoardGameTop(sortBy, limit));
    }

    @GetMapping("/{gameId}")
    @Operation(summary = "보드게임 상세 조회", description = "선택한 보드게임 상세 정보 반환")
    public ResponseEntity<BoardGameDetailResponseDto> getDetailBoardgame(
            @RequestParam(required = true) Long gameId) {
        return ResponseEntity.ok(boardgameDetailService.getBoardGameDetail(gameId));
    }
}
