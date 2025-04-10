package com.board.jamesboard.db.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "game_category")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GameCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "game_category_id")
    private Long gameCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id")
    private Game game;

    @Column(name = "game_category_name")
    private String gameCategoryName;
}
