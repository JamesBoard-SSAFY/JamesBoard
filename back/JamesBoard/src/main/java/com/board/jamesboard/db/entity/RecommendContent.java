package com.board.jamesboard.db.entity;

import jakarta.persistence.*;

@Entity
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
