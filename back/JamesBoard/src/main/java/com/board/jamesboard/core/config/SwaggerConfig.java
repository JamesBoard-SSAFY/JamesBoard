package com.board.jamesboard.core.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        // API 정보
        Info info = new Info()
                .title("JamesBoard API")
                .version("1.0")
                .description("JamesBoard API 문서");
        SecurityScheme securityScheme = new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT");

        // Security 요청 설정
        SecurityRequirement securityRequirement = new SecurityRequirement().addList("bearer-jwt");

        return new OpenAPI()
                .info(info)
                .addSecurityItem(securityRequirement)
                .components(new Components().addSecuritySchemes("bearer-jwt", securityScheme))
                .servers(List.of(
                        new Server().url("http://localhost:8080"),
                        new Server().url("https://j12d205.p.ssafy.io").description("제임스보드 API 서버")
                ));
    }

}
