package com.kdd9512.SpringMVCRE4.mapper;

import com.kdd9512.SpringMVCRE4.domain.BoardAttachVO;

import java.util.List;

// 첨부파일 처리를 위한 Mapper
public interface BoardAttachMapper {

    public void insert(BoardAttachVO vo);

    public void delete(String uuid);

    public List<BoardAttachVO> findByBno(Long bno);

    public void deleteAllFile(Long bno);

}
