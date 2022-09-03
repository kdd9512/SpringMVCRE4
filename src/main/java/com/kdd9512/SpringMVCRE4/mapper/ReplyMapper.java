package com.kdd9512.SpringMVCRE4.mapper;

import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

    public int insert(ReplyVO vo);  // 댓글 삽입.

    public ReplyVO read(Long rno); // 댓글 조회.

    public int delete(Long rno); // 댓글 삭제. 정상적으로 삭제되면 1을 출력.

    // 댓글 갱신. 정상적으로 처리되면 1을 출력.
    // insert 처럼 ReplyVO 를 param 으로 받지만 수정을 하는 작업이므로 vo 대신 reply 로 선언(그냥 알아보기 쉽게 하기 위함).
    public int update(ReplyVO reply);

    // @Param 을 이용하여 SQL 문에 파라메터 전달.
    public List<ReplyVO> getListWithPaging(
            @Param("cri") Criteria cri,
            @Param("bno") Long bno);

    // 특정 글이 가지는 댓글의 총 개수를 파악하고 화면에 출력한다.
    public int getCountByBno(Long bno);
}
