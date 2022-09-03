package com.kdd9512.SpringMVCRE4.service;

import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.domain.ReplyPageDTO;
import com.kdd9512.SpringMVCRE4.domain.ReplyVO;
import com.kdd9512.SpringMVCRE4.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Log4j
// @AllArgsConstructor -> Spring 4.3 이용시.
public class ReplyServiceImpl implements ReplyService{

    @Setter(onMethod_ = {@Autowired})
    private ReplyMapper mapper;

    // Spring 4.3 이용시.
//    private ReplyMapper mapper;

    @Override
    public int register(ReplyVO vo) {

        log.info("==========================");
        log.info("register=================" + vo);

        return mapper.insert(vo);
    }

    @Override
    public ReplyVO get(Long rno) {

        log.info("==========================");
        log.info("get=================" + rno);

        return mapper.read(rno);
    }

    @Override
    public int modify(ReplyVO vo) {

        log.info("==========================");
        log.info("modify======================" + vo);

        return mapper.update(vo);
    }

    @Override
    public int remove(Long rno) {

        log.info("==========================");
        log.info("remove======================" + rno);

        return mapper.delete(rno);
    }

    // 댓글 목록과 댓글 페이지 개수를 return
    @Override
    public ReplyPageDTO getList(Criteria cri, Long bno) {

        log.info("==========================");
        log.info("GET REPLY LIST : [CRI: " + cri + ", BNO : " + bno + " ]");

        return new ReplyPageDTO(
                mapper.getCountByBno(bno),
                mapper.getListWithPaging(cri, bno));
    }


}
