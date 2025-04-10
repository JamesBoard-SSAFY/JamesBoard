package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

    // 토큰 값을 통한 reftoken 조회
    Optional<RefreshToken> findByToken(String token);

    // userId를 통한 refresh 조회
    Optional<RefreshToken> findByUserUserId(Long user_user_id);

    // userId통한 refresh 삭제
    void deleteByUserUserId(Long user_user_id);
}
