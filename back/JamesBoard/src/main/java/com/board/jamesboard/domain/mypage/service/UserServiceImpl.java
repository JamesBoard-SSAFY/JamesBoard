package com.board.jamesboard.domain.mypage.service;

import com.board.jamesboard.core.constant.ErrorCode;
import com.board.jamesboard.core.exception.CustomException;
import com.board.jamesboard.db.entity.Archive;
import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.repository.*;
import com.board.jamesboard.domain.mypage.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserActivityRepository userActivityRepository;
    private final GameRepository gameRepository;
    private final GameCategoryRepository gameCategoryRepository;
    private final ArchiveRepository archiveRepository;
    private final ArchiveImageRepository archiveImageRepository;

    // 날짜 포맷터
    private static  final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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

    @Override
    public UserGameArchiveResponseDto getUserGameArchive(Long userId, Long gameId) {
        try {
            // 게임 정보 조회
            Game game = gameRepository.findByGameId(gameId)
                    .orElseThrow(() -> new CustomException(ErrorCode.INTERNAL_SERVER_ERROR));

            // 게임 카테고리 목록 조회
            List<String> categories = gameCategoryRepository.findCategoryNamesByGameId(gameId);

            // 사용자 작성 게임 아카이브 조회
            List<Archive> archives = archiveRepository.findByUserIdAndGameIdOrderByCreatedAtDesc(userId, gameId);

            // 아카이브 상세정보
            List<UserGameArchiveResponseDto.ArchiveDetailDto> archiveDetail = archives.stream()
                    .map(archive -> {
                        // 첫 번째 이미지 URL 조회
                        String imageUrl = archiveImageRepository.findFirstImageUrlByArchiveId(archive.getArchiveId())
                                .orElse(null);

                        // 날짜 포매팅
                        String formattedDate = archive.getCreatedAt() != null
                                ? archive.getCreatedAt().format(DATE_FORMATTER)
                                : null;

                        return UserGameArchiveResponseDto.ArchiveDetailDto.builder()
                                .archiveId(archive.getArchiveId())
                                .createdAt(formattedDate)
                                .archiveContent(archive.getArchiveContent())
                                .archiveGamePlayCount(archive.getArchiveGamePlayCount())
                                .archiveImage(imageUrl)
                                .build();

                    })
                    .collect(Collectors.toList());

            return UserGameArchiveResponseDto.builder()
                    .gameTitle(game.getGameTitle())
                    .gameImage(game.getGameImage())
                    .gameCategoryList(categories)
                    .minPlayer(game.getMinPlayer())
                    .maxPlayer(game.getMaxPlayer())
                    .difficulty(game.getGameDifficulty())
                    .playTime(game.getGamePlayTime())
                    .archiveList(archiveDetail)
                    .build();
        } catch (CustomException e) {
            throw e;
        } catch (Exception e) {
            log.error("사용자 게임 아카이브 조회 실패: {}", e.getMessage());
            throw new CustomException(ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }




}
