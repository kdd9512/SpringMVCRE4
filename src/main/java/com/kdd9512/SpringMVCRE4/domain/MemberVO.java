package com.kdd9512.SpringMVCRE4.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class MemberVO {

    // tbl_member
    private String userid;
    private String userpw;
    private String userName;
    private boolean enabled;
    private Date regDate;
    private Date updateDate;
    private List<AuthVO> authList;

}
