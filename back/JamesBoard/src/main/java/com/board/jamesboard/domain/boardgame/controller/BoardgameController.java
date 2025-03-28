package com.board.jamesboard.domain.boardgame.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.board.jamesboard.domain.boardgame.dto.BoardgameDetailDto;
import com.board.jamesboard.domain.boardgame.dto.BoardgameRecommendDto;
import com.board.jamesboard.domain.boardgame.dto.BoardgameTopDto;
import com.board.jamesboard.domain.boardgame.dto.BoardgameType;
import com.board.jamesboard.domain.boardgame.service.BoardgameDetailService;
import com.board.jamesboard.domain.boardgame.service.BoardgameRecommendService;
import com.board.jamesboard.domain.boardgame.service.BoardgameSearchService;
import com.board.jamesboard.domain.boardgame.service.BoardgameTopService;

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
public class BoardgameController {

    private final BoardgameRecommendService boardgameRecommendService;
    private final BoardgameSearchService boardgameSearchService;
    private final BoardgameTopService boardgameTopService;
    private final BoardgameDetailService boardgameDetailService;

    @GetMapping("/recommendations")
    @Operation(summary = "추천 보드게임 조회", description = "default 10으로 설정")
    public ResponseEntity<List<BoardgameRecommendDto>> getBoardgameRecommendation(@RequestParam(defaultValue = "10") Integer limit) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long userId = Long.parseLong(authentication.getName());
        
        List<BoardgameRecommendDto> recommendations = boardgameRecommendService.getBoardgameRecommends(userId, limit);
        return ResponseEntity.ok(recommendations);
    }

    @GetMapping("")
    @Operation(summary = "보드게임 조회(검색)", description = "난이도, 최소유저, 보드게임 이름, 카테고리로 구별")
    public ResponseEntity<List<BoardgameRecommendDto>> searchBoardgame(
            @RequestParam(required = false) Integer difficulty,
            @RequestParam(required = false) Integer minPlayers,
            @RequestParam(required = false) String boardgameName,
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(boardgameSearchService.BoardgameSearchService(difficulty, minPlayers, boardgameName, category));
    }

    @GetMapping("/top")
    @Operation(summary = "상위 N개의 게임 조회", description = "보드게임 id와 이미지 반환 기본값 10으로 설정")
    public ResponseEntity<List<BoardgameTopDto>> getTopBoardgame(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long boardId,
            @RequestParam(required = false) BoardgameType boardgameType,
            @RequestParam(required = false) Long page,
            @RequestParam(defaultValue = "10") Integer limit) {
        return ResponseEntity.ok(boardgameTopService.getBoardgameTop(userId, boardId, boardgameType, page, limit));
    }

    @GetMapping("/{gameId}")
    @Operation(summary = "보드게임 상세 조회", description = "선택한 보드게임 상세 정보 반환")
    public ResponseEntity<BoardgameDetailDto> getDetailBoardgame(
            @RequestParam(required = true) Long gameId) {
        return ResponseEntity.ok(boardgameDetailService.getBoardgameDetail(gameId));
    }
}
