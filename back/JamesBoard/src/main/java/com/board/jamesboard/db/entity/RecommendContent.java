package com.board.jamesboard.db.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RecommendContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "recommend_content_id", nullable = false)
    private Long recommendContentId;

    // 추천의 기준이 되는 게임
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    // 추천되는 게임
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recommend_game_id", nullable = false)
    private Game recommendGame;

    @Column(name = "recommend_content_rank")
    private Integer recommendContentRank;
}
