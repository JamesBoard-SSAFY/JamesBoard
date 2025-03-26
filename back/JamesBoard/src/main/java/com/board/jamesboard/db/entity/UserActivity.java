package com.board.jamesboard.db.entity;

import com.board.jamesboard.domain.useractivity.dto.RatingPatchRequestDto;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_activity")
@Getter
@Builder(toBuilder = true)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UserActivity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_activity_id")
    private long userActivityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id")
    private Game game;

    @Column(name = "user_activity_time")
    private Integer userActivityTime;

    @Column(name = "user_activity_rating")
    private Float userActivityRating;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "modified_at")
    @UpdateTimestamp
    private LocalDateTime modifiedAt;

    public void addPlayTime(int playTime) {
        if (this.userActivityTime == null) this.userActivityTime = 0;
        this.userActivityTime += playTime;
        this.modifiedAt = LocalDateTime.now();
    }

    public void subtractPlayTime(int playTime) {
        if (this.userActivityTime == null) this.userActivityTime = 0;
        this.userActivityTime = Math.max(0, this.userActivityTime - playTime); // 음수 방지
        this.modifiedAt = LocalDateTime.now();
    }

    public void updateUserActivityRating(Float rating) {
        this.userActivityRating = rating;
    }


}
