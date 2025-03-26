package com.board.jamesboard.domain.useractivity.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RatingPostRequestDto {
    private Long gameId;

    @NotNull
    @DecimalMin("0.5")
    @DecimalMax("5.0")
    private Float rating;
}
