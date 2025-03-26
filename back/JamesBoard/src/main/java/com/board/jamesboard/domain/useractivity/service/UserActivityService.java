package com.board.jamesboard.domain.useractivity.service;

import com.board.jamesboard.domain.useractivity.dto.UserActivityResponseDto;

import java.util.List;

public interface UserActivityService {
    List<UserActivityResponseDto> getUserActivity(Long userId, Long gameId);
}
