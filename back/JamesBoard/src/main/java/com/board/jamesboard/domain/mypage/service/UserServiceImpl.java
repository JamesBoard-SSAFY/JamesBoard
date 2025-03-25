package com.board.jamesboard.domain.mypage.service;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.UserActivityRepository;
import com.board.jamesboard.db.repository.UserRepository;
import com.board.jamesboard.domain.mypage.dto.UserGameResponseDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileResponseDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileUpdateRequestDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileUpdateResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserActivityRepository userActivityRepository;

    // 내 정보 조회
    @Override
    public UserProfileResponseDto getUserProfile(Long userId) {
        // 사용자 정보 조회
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        // 내 정보 반환
        return UserProfileResponseDto.builder()
                .userProfile(user.getUserProfile())
                .userNickname(user.getUserNickname())
                .build();

    }
    // 프로필 수정
    @Override
    @Transactional
    public UserProfileUpdateResponseDto updateUserProfile(Long userId, UserProfileUpdateRequestDto request) {
        try {
            //사용자 정보 조회
            User user = userRepository.findByUserId(userId)
                    .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

            // 프로필 정보 업데이트
            user.updateProfile(request.getUserProfile(), request.getUserName());

            log.info("사용자 프로필 업데이트 완료 : user={}", userId);

            //응답 반환
            return UserProfileUpdateResponseDto.builder()
                    .usersId(userId)
                    .build();
        } catch (CustomException e) {
            throw e;
        } catch (Exception e) {
            log.error("사용자 프로필 업데이트 실패 : {}", e.getMessage());
            throw new CustomException(ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public List<UserGameResponseDto> getUserGames(Long userId) {
        try {
            // 사용자 존재 여부 확인
            if (!userRepository.existsById(userId)) {
                throw new CustomException(ErrorCode.USER_NOT_FOUND);
            }

            // 사용자 플레이 게임 목록 조회
            List<Game> games = userActivityRepository.findDistinctGameByUserUserId(userId);

            // 게임 목록 반환
            return games.stream()
                    .map(game -> UserGameResponseDto.builder()
                            .gameId(game.getGameId())
                            .gameImage(game.getGameImage())
                            .build())
                    .collect(Collectors.toList());
        } catch (CustomException e) {
            throw e;
        } catch (Exception e) {
            log.error("사용자 게임 목록 조회 실패 : {}", e.getMessage());
            throw new CustomException(ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }




}
