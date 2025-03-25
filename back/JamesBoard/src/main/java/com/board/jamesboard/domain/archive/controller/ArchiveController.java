package com.board.jamesboard.domain.archive.controller;

import com.board.jamesboard.domain.archive.dto.ArchiveDetailResponseDto;
import com.board.jamesboard.domain.archive.dto.ArchiveRequestDto;
import com.board.jamesboard.domain.archive.dto.ArchiveResponseDto;
import com.board.jamesboard.domain.archive.service.ArchiveService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/archives")
@CrossOrigin("*")
@RequiredArgsConstructor
@Slf4j
public class ArchiveController {
    private final ArchiveService archiveService;

    @GetMapping("")
    @Operation(summary = "아카이브 전체조회(아이디와 첫번째 이미지)")
    public ResponseEntity<List<ArchiveResponseDto>> getAllArchives() {
        return ResponseEntity.ok(archiveService.getArchivesImage());
    }

    @GetMapping("/{archiveId}")
    @Operation(summary = "아카이브 상세 조회")
    public ResponseEntity<ArchiveDetailResponseDto> getArchive(@PathVariable Long archiveId) {
        return ResponseEntity.ok(archiveService.getArchiveDetail(archiveId));
    }

    @PostMapping("")
    @Operation(summary = "아카이브 추가, 추가 시 UserActivity 테이블 갱신")
    public ResponseEntity<Long> getArchiveTest(@RequestBody ArchiveRequestDto archiveRequestDto) {
        return ResponseEntity.ok(archiveService.createArchive(archiveRequestDto));
    }

    @PatchMapping("/{archiveId}")
    @Operation(summary = "아카이브 수정")
    public ResponseEntity<Long> updateArchive(@PathVariable Long archiveId, @RequestBody ArchiveRequestDto archiveRequestDto) {
        return ResponseEntity.ok(archiveService.updateArchive(archiveId, archiveRequestDto));
    }

    @DeleteMapping("/{archiveId}")
    @Operation(summary = "아카이브 삭제")
    public ResponseEntity<Long> deleteArchive(@PathVariable Long archiveId) {
        return ResponseEntity.ok(archiveService.deleteArchive(archiveId));
    }
}
