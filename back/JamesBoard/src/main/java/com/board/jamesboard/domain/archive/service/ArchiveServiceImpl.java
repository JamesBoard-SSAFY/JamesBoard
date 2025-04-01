package com.board.jamesboard.domain.archive.service;

import com.board.jamesboard.db.entity.*;
import com.board.jamesboard.db.repository.*;
import com.board.jamesboard.domain.archive.dto.ArchiveDetailResponseDto;
import com.board.jamesboard.domain.archive.dto.ArchiveImageDto;
import com.board.jamesboard.domain.archive.dto.ArchiveRequestDto;
import com.board.jamesboard.domain.archive.dto.ArchiveResponseDto;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
@AllArgsConstructor
@Slf4j
public class ArchiveServiceImpl implements ArchiveService {

    private final ArchiveRepository archiveRepository;
    private final ArchiveImageRepository archiveImageRepository;
    private final UserRepository userRepository;
    private final GameRepository gameRepository;
    private final UserActivityRepository userActivityRepository;

    @Override
    public List<ArchiveResponseDto> getArchivesImage() {
        // 1. 아카이브 전체 조회
        List<Archive> archiveList = archiveRepository.findAll();

        // 아카이브를 이미지와 함께 조회해서 N + 1 해결
        List<Archive> archiveListWithImages = archiveRepository.findAllArchiveWithImage();

        archiveListWithImages.forEach(archive -> {
            log.debug("Archive ID: {}", archive.getArchiveId());
            archive.getArchiveImages().forEach(image ->
                    log.debug("  → Image ID: {}, URL: {}", image.getArchiveImageId(), image.getArchiveImageUrl())
            );
        });

        return archiveListWithImages.stream()
                .map(archive -> new ArchiveResponseDto(
                        archive.getArchiveId(),
                        archive.getArchiveImages().get(0).getArchiveImageUrl()
                ))
                .toList();

    }

    @Override
    public ArchiveDetailResponseDto getArchiveDetail(Long archiveId) {

        Archive archive = archiveRepository.findById(archiveId)
                .orElseThrow(() -> new RuntimeException("Archive not found"));

        List<ArchiveImage> archiveImageList = archiveImageRepository.findByArchive(archive);

        User createUser = archive.getUser();
        Game playedGame = archive.getGame();

        log.debug("Archive userId: {}",
                createUser.getUserId());

        log.debug("Archive image list: {}",
                archiveImageList.stream()
                        .map(img -> "[id=" + img.getArchiveImageId() + ", url=" + img.getArchiveImageUrl() + "]")
                        .toList()
        );

        List<String> archiveImageUrlList = archiveImageList.stream()
                .map(ArchiveImage::getArchiveImageUrl)
                .toList();


        return new ArchiveDetailResponseDto(
                archive.getArchiveId(),
                createUser.getUserNickname(),
                createUser.getUserProfile(),
                archive.getArchiveContent(),
                playedGame.getGameTitle(),
                archive.getArchiveGamePlayTime(),
                archive.getArchiveGamePlayCount(),
                archiveImageUrlList
        );

    }

    @Override
    public Long createArchive(ArchiveRequestDto archiveRequestDto) {

        // JWT 현재 userId 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        Long userId = Long.parseLong(authentication.getName());

        Game game = gameRepository.findById(archiveRequestDto.getGameId())
                .orElseThrow(() -> new RuntimeException("해당 게임이 존재하지 않습니다."));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저가 존재하지 않습니다."));

        Archive archive = Archive.builder()
                .archiveContent(archiveRequestDto.getArchiveContent())
                .archiveGamePlayTime(archiveRequestDto.getArchiveGamePlayTime())
                .archiveGamePlayCount(archiveRequestDto.getArchiveGamePlayCount())
                .game(game)
                .user(user)
                .build();


        List<String> archiveImageList = archiveRequestDto.getArchiveImageList();

        List<ArchiveImage> archiveImages = archiveImageList.stream()
                .map(imageUrl -> ArchiveImage.builder()
                        .archiveImageUrl(imageUrl)
                        .archive(archive)
                        .build())
                .toList();

        archiveImageRepository.saveAll(archiveImages);

        Archive savedArchive = archiveRepository.save(archive);

        int playTime = archive.getArchiveGamePlayTime();
        Instant now = Instant.now();

        userActivityRepository.findByUserAndGame(user, game)
                .ifPresentOrElse(
                        activity -> {
                            activity.addPlayTime(playTime);
                            userActivityRepository.save(activity);
                        },
                        () -> {
                            UserActivity newActivity = UserActivity.builder()
                                    .user(user)
                                    .game(game)
                                    .userActivityTime(playTime)
                                    .userActivityRating(null)
                                    .build();
                            userActivityRepository.save(newActivity);
                        }
                );

        return savedArchive.getArchiveId();
    }

    @Override
    public Long updateArchive(Long archiveId, ArchiveRequestDto archiveRequestDto) {

        // 현재 JWT 유저 ID
        Long currentUserId = Long.parseLong(SecurityContextHolder.getContext().getAuthentication().getName());

        Archive archive = archiveRepository.findByArchiveId(archiveId);

        // 요청 보내는 사용자와 작성한 사용자가 다르면 에러
        if (!archive.getUser().getUserId().equals(currentUserId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        Game newGame = gameRepository.findById(archiveRequestDto.getGameId())
                .orElseThrow(() -> new RuntimeException("해당 게임이 존재하지 않습니다."));

        User user = archive.getUser(); // 현재 아카이브 작성자

        Game oldGame = archive.getGame();
        int oldPlayTime = archive.getArchiveGamePlayTime();
        int newPlayTime = archiveRequestDto.getArchiveGamePlayTime();
        Instant now = Instant.now();

        userActivityRepository.findByUserAndGame(user, oldGame)
                .ifPresent(activity -> {
                    activity.subtractPlayTime(oldPlayTime);
                    userActivityRepository.save(activity);
                });

        userActivityRepository.findByUserAndGame(user, newGame)
                .ifPresentOrElse(
                        activity -> {
                            activity.addPlayTime(newPlayTime);
                            userActivityRepository.save(activity);
                        },
                        () -> {
                            UserActivity newActivity = UserActivity.builder()
                                    .user(user)
                                    .game(newGame)
                                    .userActivityTime(newPlayTime)
                                    .userActivityRating(null)
                                    .build();
                            userActivityRepository.save(newActivity);
                        }
                );

        // 먼저 등록된 이미지들 모두 삭제
        archiveImageRepository.deleteArchiveImageByArchive(archive);

        // DTO 포함된 이미지 등록
        List<String> requestImageList = archiveRequestDto.getArchiveImageList();

        List<ArchiveImage> archiveImages = requestImageList.stream()
                .map(images -> ArchiveImage.builder()
                        .archiveImageUrl(images)
                        .archive(archive)
                        .build())
                .toList();

        archiveImageRepository.saveAll(archiveImages);

        //  아카이브 내용 업데이트
        archive.updateArchive(
                archiveRequestDto.getArchiveContent(),
                archiveRequestDto.getArchiveGamePlayTime(),
                archiveRequestDto.getArchiveGamePlayCount(),
                newGame
        );

        return archive.getArchiveId();
    }

    @Override
    public Long deleteArchive(Long archiveId) {

        // 현재 JWT 유저 ID
        Long currentUserId = Long.parseLong(SecurityContextHolder.getContext().getAuthentication().getName());

        Archive archive = archiveRepository.findById(archiveId)
                .orElseThrow(() -> new RuntimeException("해당 아카이브가 존재하지 않습니다."));

        if (!archive.getUser().getUserId().equals(currentUserId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        // 아카이브 정보 추출
        User user = archive.getUser();
        Game game = archive.getGame();
        int playTime = archive.getArchiveGamePlayTime();

        // userActivity 갱신
        userActivityRepository.findByUserAndGame(user, game)
                .ifPresent(activity -> {
                    activity.subtractPlayTime(playTime);
                    userActivityRepository.save(activity);
                });

        Long deletedArchiveId = archive.getArchiveId();
        archiveRepository.deleteById(archiveId);
        return deletedArchiveId;
    }


}
