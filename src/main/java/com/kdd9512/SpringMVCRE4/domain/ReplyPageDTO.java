package com.kdd9512.SpringMVCRE4.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

import java.util.List;

// 댓글의 목록과 그 목록이 갖는 총 페이지 수를 담는 역할을 맡는다.

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO {

    private int replyCnt; // 총 페이지 수
    private List<ReplyVO> list; // 댓글 목록

}
