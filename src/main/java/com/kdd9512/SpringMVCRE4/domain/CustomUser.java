package com.kdd9512.SpringMVCRE4.domain;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;
import java.util.stream.Collectors;

@Getter
public class CustomUser extends User {

    private static final long serialVersionUID = 1L;
    private MemberVO member;

    public CustomUser(String username, String password,
                      Collection<? extends GrantedAuthority> authority) {

        super(username, password, authority);
    }

    public CustomUser(MemberVO vo) {
        super(vo.getUserid(), vo.getUserpw(),
                vo.getAuthList().stream().map(auth ->
                    new SimpleGrantedAuthority(auth.getAuth()))
                        .collect(Collectors.toList()));

        this.member = vo;
    }

}
