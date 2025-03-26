package com.board.jamesboard.domain.useractivity.service;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.entity.UserActivity;
import com.board.jamesboard.db.repository.GameRepository;
import com.board.jamesboard.db.repository.UserActivityRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.useractivity.dto.RatingPatchRequestDto;
import com.board.jamesboard.domain.useractivity.dto.RatingPostRequestDto;
import com.board.jamesboard.domain.useractivity.dto.UserActivityResponseDto;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor(onConstructor = @__(@Autowired))
@Transactional
@Slf4j
public class UserActivityServiceImpl implements UserActivityService {

    private final UserActivityRepository userActivityRepository;
    private final UserRepository userRepository;
    private final GameRepository gameRepository;

    @Override
    public List<UserActivityResponseDto> getUserActivity(Long userId, Long gameId) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        Long currentUserId = Long.parseLong(authentication.getName());

        // 요청 보내는 사용자와 작성한 사용자가 다르면 에러
        if (!userId.equals(currentUserId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자가 존재하지 않습니다."));

        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("게임이 존재하지 않습니다."));

        List<UserActivity> userActivityList = userActivityRepository.findAllByUserAndGame(user, game);

        return userActivityList.stream()
                .map(activity -> new UserActivityResponseDto(
                        activity.getUserActivityId()
                ))
                .toList();
    }

    @Override
    public Long updateUserActivityRating(Long userActivityId, RatingPatchRequestDto ratingPatchRequestDto) {
        Long currentUserId = Long.parseLong(SecurityContextHolder.getContext().getAuthentication().getName());

        UserActivity userActivity = userActivityRepository.findByUserActivityId(userActivityId);

        // 요청 보내는 사용자와 작성한 사용자가 다르면 에러
        if (!userActivity.getUser().getUserId().equals(currentUserId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        if (ratingPatchRequestDto.getRating() < 0.5 || ratingPatchRequestDto.getRating() > 5.0) {
            throw new IllegalArgumentException("평점은 0.5 이상 5.0 이하만 가능합니다.");
        }

        userActivity.updateUserActivityRating(ratingPatchRequestDto.getRating());

        return userActivity.getUserActivityId();
    }

    @Override
    public Long createUserActivityRating(RatingPostRequestDto ratingPostRequestDto) {

        // JWT 현재 userId 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        Long userId = Long.parseLong(authentication.getName());

        if (ratingPostRequestDto.getRating() < 0.5 || ratingPostRequestDto.getRating() > 5.0) {
            throw new IllegalArgumentException("평점은 0.5 이상 5.0 이하만 가능합니다.");
        }

        Game game = gameRepository.findById(ratingPostRequestDto.getGameId())
                .orElseThrow(() -> new RuntimeException("해당 게임이 존재하지 않습니다."));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저가 존재하지 않습니다."));

        UserActivity userActivity = UserActivity.builder()
                .userActivityRating(ratingPostRequestDto.getRating())
                .game(game)
                .user(user)
                .build();

        UserActivity savedUserActivity = userActivityRepository.save(userActivity);

        return savedUserActivity.getUserActivityId();
    }
}
