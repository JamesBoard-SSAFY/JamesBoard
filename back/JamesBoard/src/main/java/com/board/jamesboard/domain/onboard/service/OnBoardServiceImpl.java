package com.board.jamesboard.domain.onboard.service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.GameCategoryRepository;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.onboard.dto.OnBoardResponseDto;
import com.board.jamesboard.domain.onboard.dto.PreferGameRequestDto;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor(onConstructor = @__(@Autowired))
@Transactional
public class OnBoardServiceImpl implements OnBoardService {

    private final GameCategoryRepository gameCategoryRepository;

    private final GameRepository gameRepository;

    private final UserRepository userRepository;

    @Override
    public List<OnBoardResponseDto> getOnBoardGames(String category) {

        // Category 입력 받아서 게임ID 조회
        List<Long> gameIdList = gameCategoryRepository.findByGameCategoryName(category)
                .stream()
                .map(gameCategory -> gameCategory.getGame().getGameId()) // Game 객체에서 ID 추출
                .toList();

        List<Game> games = gameRepository.findTop30ByGameIdInOrderByGameRank(gameIdList);

        return games.stream()
                .map(game -> new OnBoardResponseDto(game.getGameId(), game.getGameTitle())) // DTO 변환
                .toList();
    }

    @Override
    public Long updateUserPreferGame(Long userId, PreferGameRequestDto preferGameRequestDto) {

        // JWT 현재 userId 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        Long jwtUserId = Long.parseLong(authentication.getName());

        if(!jwtUserId.equals(userId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Game preferGame = gameRepository.findById(preferGameRequestDto.getGameId())
                .orElseThrow(() -> new RuntimeException("Game not found"));

        // 3. preferGame 변경 (setter 없이 새로운 객체 생성)
        user.updatePreferGame(preferGame);

        return user.getUserId();
    }
}
