package com.kdd9512.SpringMVCRE4.service;

import com.kdd9512.SpringMVCRE4.domain.BoardAttachVO;
import com.kdd9512.SpringMVCRE4.domain.BoardVO;
import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.mapper.BoardAttachMapper;
import com.kdd9512.SpringMVCRE4.mapper.BoardMapper;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j
@AllArgsConstructor
@Service
public class BoardServiceImpl implements BoardService {

    @Setter(onMethod_ = @Autowired)
    private BoardMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

    @Transactional // 한 메서드에서 두 개 이상의 작업을 해야 하므로.
    @Override
    public void register(BoardVO board) {
        log.info("register : [ " + board + " ]");

        mapper.insertSelectKey(board);

        if (board.getAttachList() == null || board.getAttachList().size() <= 0){
            return;
        }

        board.getAttachList().forEach(attach -> {
            attach.setBno(board.getBno());
            attachMapper.insert(attach);
        });

    }

    @Override
    public BoardVO get(Long bno) {

        log.info("===================================GET : [ " + bno + " ]======================================");
        return mapper.read(bno);
    }

    @Override
    public boolean modify(BoardVO board) {
        log.info("modify : [ " + board + " ]");

        // 기존 첨부파일 데이터 삭제 후 다시 첨부파일 데이터를 삽입.
        // 기존파일은 modify 창에서 param 으로 남아있으므로 기존파일이 지워지는게 아님.
        attachMapper.deleteAllFile(board.getBno());
        boolean modifyResult = mapper.update(board) == 1; // true / false 를 1과 0 으로 구분하므로

        if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
            board.getAttachList().forEach(attach -> {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);

            });
        }
        return modifyResult;
    }

    @Transactional
    @Override
    public boolean remove(Long bno) {
        log.info("remove : [ " + bno + " ]");

        attachMapper.deleteAllFile(bno);

        return mapper.delete(bno) == 1; // true / false 를 1과 0 으로 구분하므로
    }

//    @Override
//    public List<BoardVO> getList() {
//
//        log.info("===========================getList===========================");
//        return mapper.getList();
//    }

    @Override
    public List<BoardVO> getList(Criteria cri) {

        log.info("==========================getList with Criteria [ " + cri + " ]============================");
        return mapper.getListWithPaging(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        log.info("get total count======================================================");
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<BoardAttachVO> getAttachList(Long bno) {
        log.info("get attach list by bno : " + bno);

        return attachMapper.findByBno(bno);

    }


}
