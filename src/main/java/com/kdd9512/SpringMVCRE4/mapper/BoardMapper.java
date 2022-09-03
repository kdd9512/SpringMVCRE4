package com.kdd9512.SpringMVCRE4.mapper;

import com.kdd9512.SpringMVCRE4.domain.BoardVO;
import com.kdd9512.SpringMVCRE4.domain.Criteria;

import java.util.List;

public interface BoardMapper {
    // resources 의 xml 파일로 대체하였으므로 주석처리.
    // @Select("select * from tbl_board where bno > 0")
    public List<BoardVO> getList();

    public List<BoardVO> getListWithPaging(Criteria cri);

    public void insert(BoardVO board);

    public void insertSelectKey(BoardVO board);

    public BoardVO read(Long bno); // bno 를 param 으로 받아 컬럼의 정보를 읽고 그 정보는 VO 에 담는다.

    public int delete(Long bno); // 정상적으로 삭제되면 1을 출력.

    public int update(BoardVO board); // 정상적으로 갱신되었다면 1을 출력할 것.

    public int getTotalCount(Criteria cri); // 전체 데이터의 개수처리.

}
