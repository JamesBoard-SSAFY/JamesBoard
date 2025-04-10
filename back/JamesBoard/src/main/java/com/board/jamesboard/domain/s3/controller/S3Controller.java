package com.board.jamesboard.domain.s3.controller;

import com.board.jamesboard.domain.s3.service.S3ServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/s3")
@CrossOrigin("*")
public class S3Controller {

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucket;

    @Autowired
    S3ServiceImpl s3Service;

    @PostMapping("/presigned-url")
    @Operation(summary = "url 발급")
    public String getUrl(@RequestParam String fileName) {
        return s3Service.getPreSignedUrl(fileName);
    }

}

