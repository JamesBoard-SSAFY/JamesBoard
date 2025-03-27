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

import com.board.jamesboard.domain.boardgame.dto.BoardgameRecommendDto;
import com.board.jamesboard.domain.boardgame.service.BoardgameRecommendService;
import com.board.jamesboard.domain.boardgame.service.BoardgameSearchService;
import com.board.jamesboard.domain.boardgame.type.BoardgameType;

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

    @GetMapping("/recommendations")
    public ResponseEntity<List<BoardgameRecommendDto>> getBoardgameRecommendation(@RequestParam(defaultValue = "10") Integer limit) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long userId = Long.parseLong(authentication.getName());
        
        List<BoardgameRecommendDto> recommendations = boardgameRecommendService.getBoardgameRecommends(userId, limit);
        return ResponseEntity.ok(recommendations);
    }

    @GetMapping("")
    public ResponseEntity<List<BoardgameRecommendDto>> searchBoardgame(
            @RequestParam(required = false) Integer difficulty,
            @RequestParam(required = false) Integer minPlayers,
            @RequestParam(required = false) String boardgameName,
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(boardgameSearchService.BoardgameSearchService(difficulty, minPlayers, boardgameName, category));
    }

    @GetMapping("/top")
    public ResponseEntity<List<BoardgameRecommendDto>> getTopBoardgame(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long boardId,
            @RequestParam(required = false) BoardgameType boardType,
            @RequestParam(required = false) Long page,
            @RequestParam(defaultValue = "10") Integer limit
    ) {
        return ResponseEntity.ok(boardgameRecommendService.getTopBoardgame(userId, boardId, boardType, page, limit));
    }
}
