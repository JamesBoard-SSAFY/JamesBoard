package com.board.jamesboard.db.repository;

import com.board.jamesboard.db.entity.Game;
import com.board.jamesboard.db.entity.User;
import com.board.jamesboard.db.entity.UserActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface
UserActivityRepository extends JpaRepository<UserActivity, Long> {
    Optional<UserActivity> findByUserAndGame(User user, Game game);

    @Query("SELECT DISTINCT ua.game FROM UserActivity ua WHERE ua.user.userId = :userId " +
            "AND ua.userActivityTime IS NOT NULL AND ua.userActivityTime > 0")
    List<Game> findDistinctGameByUserUserId(Long userId);

    List<UserActivity> findAllByUserAndGame(User user, Game game);

    UserActivity findByUserActivityId(long userActivityId);

    // 해당 유저가 작성한 리뷰개수
    Long countByUserUserIdAndUserActivityRatingIsNotNull(Long userId);


    @Query("SELECT ua.game FROM UserActivity ua WHERE ua.user.userId = :userId " +
            "AND ua.userActivityTime IS NOT NULL AND ua.userActivityTime > 0 " +
            "GROUP BY ua.game.gameId ORDER BY MAX(ua.createdAt) DESC")
    List<Game> findDistinctGameByUserUserIdOrderByLatestActivityDesc(@Param("userId") Long userId);

}
