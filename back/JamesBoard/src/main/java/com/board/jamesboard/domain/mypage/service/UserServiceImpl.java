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
import java.util.*;
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
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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
                            .gameImage(game.getBigThumbnail())
                            .build())
                    .sorted(Comparator.comparing(UserGameResponseDto::getGameId))
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
            List<Archive> archives = archiveRepository.findByUserUserIdAndGameGameIdOrderByCreatedAtDesc(userId, gameId);

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
                    .minAge(game.getGameMinAge())
                    .gameYear(game.getGameYear())
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

    @Override
    public List<String> getAllStandardCategoryNames() {

        // 카테고리 이름 목록 조회
        List<String> categories = gameCategoryRepository.findDistinctCategoryNames();

        //기본 목록 제공
        if (categories == null || categories.isEmpty()) {
            log.warn("DB에 해당 카테고리가 없습니다. 기본 카테고리를 사용합니다");
            return List.of("파티", "전략", "경제", "모험", "롤플레잉", "가족", "추리", "전쟁", "추상전략");
        }

        return categories;
    }

    //사용자 보드게임 통계 및 순위 정보 조회
    @Override
    public UserStatsResponseDto getUserGameStats(Long userId) {
        try {
            // 사용자 존재 여부 검증
            if (!userRepository.existsById(userId)) {
                throw new CustomException(ErrorCode.USER_NOT_FOUND);
            }

            // 표준 카테고리 조회
            List<String> standardCategories = getAllStandardCategoryNames();

            // 총 플레이 횟수 조회
            Integer totalPlayed = archiveRepository.getTotalPlayByUserId(userId);

            // 가장 많이 플레이한 게임 목록 조회
            List<Object[]> topPlayedGamesData = archiveRepository.getTopPlayGamesByUserId(userId);

            List<UserStatsResponseDto.TopPlayedGame> topPlayedGames = topPlayedGamesData.stream()
                    .map(data -> UserStatsResponseDto.TopPlayedGame.builder()
                            .gameId(((Number) data[0]).longValue())
                            .gameTitle((String) data[1])
                            .gameImage((String) data[2])
                            .totalPlayCount(((Number) data[3]).intValue())
                            .build())
                    .collect(Collectors.toList());

            // 카테고리별 통계조회
            List<Object[]> genreStatsData = archiveRepository.getGenreStatsByUserIdGroupByName(userId);

            // 카테고리별 플탐 맵으로 변환
            Map<String, Integer> categoryCountMap = new HashMap<>();
            for (Object[] data : genreStatsData) {
                String categoryName = (String) data[0];
                Integer count = ((Number) data[1]).intValue();

                // 동일이름 매핑 처리
                for (String predefinedCategory : standardCategories) {
                    if (categoryName.equalsIgnoreCase(predefinedCategory)) {
                        // 존재시 누적, 없으면 추가
                        categoryCountMap.merge(predefinedCategory, count, Integer::sum);
                        break;
                    }
                }
            }

            // 모든 카테고리 카운트 합 계산
            int totalCategoryCount = categoryCountMap.values().stream()
                    .mapToInt(Integer::intValue)
                    .sum();

            List<UserStatsResponseDto.GenreStats> genres = standardCategories.stream()
                    .map(category -> {
                        // 해당 카테고리 플레이 횟수 (없으면 0)
                        Integer count = categoryCountMap.getOrDefault(category, 0);

                        // 퍼센티지 계산 (총 플레이 횟수 0일시 퍼센티지도 0)
                        Double percentage = totalCategoryCount > 0
                                ? Math.round((double) count / totalCategoryCount * 1000) / 10.0
                                : 0.0;

                        return UserStatsResponseDto.GenreStats.builder()
                                .gameCategoryName(category)
                                .count(count)
                                .percentage(percentage)
                                .build();
                    })
                    .collect(Collectors.toList());

            return UserStatsResponseDto.builder()
                    .totalPlayed(totalPlayed)
                    .genreStats(genres)
                    .topPlayedGames(topPlayedGames)
                    .build();

        } catch (CustomException e) {
            throw e;
        } catch (Exception e) {
            log.error("사용자 게임 통계 및 순위 조회 실패 : {}", e.getMessage());
            throw new CustomException(ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public Long getUserPreferGame(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        Game preferGame = user.getPreferGame();

        return (preferGame != null && preferGame.getGameId() != null)
                ? preferGame.getGameId()
                : -1L;
    }
}