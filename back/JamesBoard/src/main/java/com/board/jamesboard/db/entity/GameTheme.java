package com.board.jamesboard.db.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "game_theme")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PROTECTED)
public class GameTheme {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "game_theme_id")
    private Long gameThemeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id")
    private Game game;

    @Column(name = "game_theme_name")
    private String gameThemeName;



}
