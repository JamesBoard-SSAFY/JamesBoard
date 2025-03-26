package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Archive;
import com.board.jamesboard.db.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByLoginId(String loginId);

    // 실제 존재 여부 확인
    boolean existsByLoginId(String loginId);

    Optional<User> findByUserId(Long userId);

//    List<Archive> findByUserIdAndGameIdOrderByCreatedAtDesc(Long userId, Long gameId);

}
