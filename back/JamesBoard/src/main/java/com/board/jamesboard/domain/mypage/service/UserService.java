package com.board.jamesboard.domain.mypage.service;

import com.board.jamesboard.domain.mypage.dto.*;

import java.util.List;

public interface UserService {

    //내 정보 조회
    UserProfileResponseDto getUserProfile(Long userId);

    //프로필 정보 수정
    UserProfileUpdateResponseDto updateUserProfile(Long userId, UserProfileUpdateRequestDto request);

    //프로필 게임 목록 조회ㅐ
    List<UserGameResponseDto> getUserGames(Long userId);

    // 사용자 아카이미 목록 조회 (딴일)
    UserGameArchiveResponseDto getUserGameArchive(Long userId, Long gameId);

    // 사용자 보드게임 통계 및 순위 정보 조회
    UserStatsResponseDto getUserGameStats(Long userId);

    // 표준 게임 카테고리 이름 목록 조회
    List<String> getAllStandardCategoryNames();

    // 유저 선호 게임 조회
    Long getUserPreferGame(Long userId);
}
