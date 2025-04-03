package com.board.jamesboard.db.entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "game")
@Entity
public class Game {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "game_id", nullable = false)
    private Long gameId;

    @Size(max = 255)
    @Column(name = "game_title")
    private String gameTitle;

    @Column(name = "game_description", columnDefinition = "TEXT")
    private String gameDescription;

    @Size(max = 255)
    @Column(name = "big_thumbnail")
    private String bigThumbnail;

    @Size(max = 255)
    @Column(name = "small_thumbnail")
    private String smallThumbnail;

    @Size(max = 255)
    @Column(name = "game_image")
    private String gameImage;

    @Column(name = "game_year")
    private Integer gameYear;

    @Column(name = "min_player")
    private Integer minPlayer;

    @Column(name = "max_player")
    private Integer maxPlayer;

    @Column(name = "game_play_time")
    private Integer gamePlayTime;

    @Column(name = "game_min_age")
    private Integer gameMinAge;

    @Size(max = 255)
    @Column(name = "game_publisher")
    private String gamePublisher;

    @Column(name = "game_difficulty")
    private Integer gameDifficulty;

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GameCategory> gameCategories = new ArrayList<>();

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GameDesigner> gameDesigners = new ArrayList<>();

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<GameTheme> gameThemes = new ArrayList<>();

    @Column(name = "game_rank")
    private Integer gameRank;

    @Column(name = "game_avg_rating")
    private Float gameAvgRating;

    @Column(name = "game_review_count")

    private Integer gameReviewCount;

    @OneToMany(mappedBy = "game")
    private List<Archive> archives = new ArrayList<>();

    @OneToMany(mappedBy = "game")
    private List<Recommend> recommends = new ArrayList<>();

    @OneToMany(mappedBy = "game")
    private List<UserActivity> userActivities = new ArrayList<>();

    // 사용자가 선호한 게임
    @OneToMany(mappedBy = "game")
    private List<RecommendContent> recommendContents = new ArrayList<>();
    
    // 추천된 게임
    @OneToMany(mappedBy = "recommendGame")
    private List<RecommendContent> recommendedContent = new ArrayList<>();

    public void updateAverageRating(Float averageRating) {
        this.gameAvgRating = averageRating;
    }

}
