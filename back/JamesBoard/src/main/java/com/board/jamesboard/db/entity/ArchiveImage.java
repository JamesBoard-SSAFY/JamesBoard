package com.board.jamesboard.db.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "archive_image")
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ArchiveImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "archive_image_id")
    private Long archiveImageId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "archive_id")
    private Archive archive;

    @Column(name = "archive_image_url")
    private String archiveImageUrl;

}
