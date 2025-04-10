package com.board.jamesboard.db.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "game_designer")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GameDesigner {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "game_designer_id")
    private Long gameDesignerId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id")
    private Game game;

    @Column(name = "game_designer_name")
    private String gameDesignerName;

}
