package com.kdd9512.SpringMVCRE4.service;

import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.domain.ReplyPageDTO;
import com.kdd9512.SpringMVCRE4.domain.ReplyVO;

public interface ReplyService {

    public int register(ReplyVO vo);

    public ReplyVO get(Long rno);

    public int modify(ReplyVO vo);

    public int remove(Long rno);

    public ReplyPageDTO getListPage(Criteria cri, Long bno);

}
