package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.entity.UserActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserActivityRepository extends JpaRepository<UserActivity, Long> {
    Optional<UserActivity> findByUserAndGame(User user, Game game);

    @Query("SELECT DISTINCT ua.game FROM UserActivity ua WHERE ua.user.userId = :userId")
    List<Game> findDistinctGameByUserUserId(Long userId);

    List<UserActivity> findAllByUserAndGame(User user, Game game);

    UserActivity findByUserActivityId(long userActivityId);
}
