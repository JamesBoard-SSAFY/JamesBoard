package com.board.jamesboard.domain.s3.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode
public class S3Dto {

    private String preSignedUrl;

    private String key;

    @Builder
    public S3Dto(String preSignedUrl, String key) {
        this.preSignedUrl = preSignedUrl;
        this.key = key;
    }
}

