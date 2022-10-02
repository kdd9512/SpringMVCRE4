package com.kdd9512.SpringMVCRE4.service;

import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.domain.ReplyPageDTO;
import com.kdd9512.SpringMVCRE4.domain.ReplyVO;
import com.kdd9512.SpringMVCRE4.mapper.BoardMapper;
import com.kdd9512.SpringMVCRE4.mapper.ReplyMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j
// @AllArgsConstructor -> Spring 4.3 이용시.
public class ReplyServiceImpl implements ReplyService {

    @Setter(onMethod_ = {@Autowired})
    private ReplyMapper mapper;

    @Setter(onMethod_ = {@Autowired})
    private BoardMapper boardMapper;

    // Spring 4.3 이용시.
//    private ReplyMapper mapper;

    @Transactional // 한 메서드에서 두 개 이상의 작업을 해야 하므로.
    @Override
    public int register(ReplyVO vo) {

        log.info("==========================");
        log.info("register : [ " + vo + " ]");

        boardMapper.updateReplyCnt(vo.getBno(), 1); // 삭제 후 댓글 증가.

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

    @Transactional // 한 메서드에서 두 개 이상의 작업을 해야 하므로.
    @Override
    public int remove(Long rno) {

        log.info("==========================");
        log.info("remove : [ " + rno + " ]");

        ReplyVO vo = mapper.read(rno);

        boardMapper.updateReplyCnt(vo.getBno(), -1); // 삭제 후 댓글 감소

        return mapper.delete(rno);
    }

    // 댓글 목록과 댓글 페이지 개수를 return
    @Override
    public ReplyPageDTO getListPage(Criteria cri, Long bno) {

        log.info("==========================");
        log.info("GET REPLY LIST : [CRI: " + cri + ", BNO : " + bno + " ]");

        return new ReplyPageDTO(
                mapper.getCountByBno(bno),
                mapper.getListWithPaging(cri, bno));
    }


}
