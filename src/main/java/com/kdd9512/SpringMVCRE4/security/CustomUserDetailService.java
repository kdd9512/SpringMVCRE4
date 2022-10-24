package com.kdd9512.SpringMVCRE4.security;

import com.kdd9512.SpringMVCRE4.domain.CustomUser;
import com.kdd9512.SpringMVCRE4.domain.MemberVO;
import com.kdd9512.SpringMVCRE4.mapper.MemberMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;


@Log4j
public class CustomUserDetailService implements UserDetailsService {

    @Setter(onMethod_ = @Autowired)
    private MemberMapper mapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        log.warn("Load User By UserName : " + username);
        MemberVO vo = mapper.read(username);
        log.warn("queried by member mapper : " + vo);

        return vo == null ? null : new CustomUser(vo);
    }
}
