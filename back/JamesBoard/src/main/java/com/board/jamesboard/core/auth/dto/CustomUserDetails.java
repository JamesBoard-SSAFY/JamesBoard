package com.board.jamesboard.core.auth.dto;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.Collection;

public class CustomUserDetails implements UserDetails {

    private Long userId;

    // 권한 목록
    private Collection<GrantedAuthority> authorities;

    public CustomUserDetails(Long userId) {
        this.userId = userId;
        this.authorities = new ArrayList<>();
        //기본권한 부여
        this.authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
    }

    public Long getUserId() {
        return userId;
    }

    private Collection<GrantedAuthority> createAuthorities(String roles) {
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        for (String role : roles.split(",")) {
            if (!StringUtils.hasText(role)) continue;
            authorities.add(new SimpleGrantedAuthority(role));
        }
        return authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        // oauth로 대체
        return null;
    }

    @Override
    public String getUsername() {
        // 사용자 ID 문자열 반환
        return String.valueOf(userId);
    }

    @Override
    public boolean isAccountNonExpired() {
        // 만료 여부 (true / false)
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        // 잠김 여부 (true / false)
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        // 자격 증명 만료 여부
        return true;
    }

    @Override
    public boolean isEnabled() {
        // 계정 활성화 여부
        return true;
    }
}
