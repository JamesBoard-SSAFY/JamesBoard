package com.board.jamesboard.domain.s3.service;

public interface S3Service {
    String getPreSignedUrl(String fileName);
}

