package com.board.jamesboard.domain.boardgame.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.domain.boardgame.dto.BoardgameTopDto;
import com.board.jamesboard.domain.boardgame.dto.BoardgameType;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardgameTopServiceImpl implements BoardgameTopService {

    private final GameRepository gameRepository;

    @Override
    public List<BoardgameTopDto> getBoardgameTop(Long userId, Long boardId, BoardgameType boardType, Long page, Integer limit) {
        // TODO: GameRepository에 적절한 메서드 추가 필요
        // 임시로 모든 게임을 가져와서 정렬하는 방식으로 구현
        return gameRepository.findAll().stream()
                .sorted((a, b) -> b.getGameRank().compareTo(a.getGameRank()))  // 게임 순위로 정렬
                .skip(page * limit)  // 페이지네이션
                .limit(limit)  // limit 개수만큼만 가져오기
                .map(game -> new BoardgameTopDto(
                    game.getGameId(),
                    game.getGameImage()
                ))
                .collect(Collectors.toList());
    }
}
