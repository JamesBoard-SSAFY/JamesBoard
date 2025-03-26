package com.board.jamesboard.domain.mypage.service;

import com.board.jamesboard.domain.mypage.dto.UserGameResponseDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileResponseDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileUpdateRequestDto;
import com.board.jamesboard.domain.mypage.dto.UserProfileUpdateResponseDto;

import java.util.List;

public interface UserService {

    //내 정보 조회
    UserProfileResponseDto getUserProfile(Long userId);

    //프로필 정보 수정
    UserProfileUpdateResponseDto updateUserProfile(Long userId, UserProfileUpdateRequestDto request);

    //프로필 게임 목록 조회ㅐ
    List<UserGameResponseDto> getUserGames(Long userId);
}
