package com.kdd9512.SpringMVCRE4.controller;

import com.kdd9512.SpringMVCRE4.domain.Criteria;
import com.kdd9512.SpringMVCRE4.domain.ReplyPageDTO;
import com.kdd9512.SpringMVCRE4.domain.ReplyVO;
import com.kdd9512.SpringMVCRE4.service.ReplyService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RequestMapping(value = "/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

    private ReplyService service;


    @PreAuthorize("isAuthenticated()")
    @PostMapping(value = "/new",
            consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> create(
            // JSON 데이터를 @ResponseBody 를 적용한 타입(ReplyVO)으로 형변환한다.
            @RequestBody ReplyVO vo) {

        log.info("ReplyVO : " + vo);

        int insertCnt = service.register(vo);

        log.info("Reply InsertCnt : " + insertCnt);

        return insertCnt == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

    }

    @GetMapping(value="/pages/{bno}/{page}",
            produces = {
            MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page,
                                                @PathVariable("bno") Long bno) {

        log.info("getList=======================================");

        Criteria cri = new Criteria(page, 10);

        log.info("get Reply List bno : " + bno);
        log.info("cri : " + cri);

        return new ResponseEntity<>(service.getListPage(cri,bno), HttpStatus.OK);

    }

    // 댓글 조회
    @GetMapping(value = "/{rno}",
            produces = {
            MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
    public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {

        log.info("get : " + rno);

        return new ResponseEntity<>(service.get(rno), HttpStatus.OK);

    }

    // 댓글 삭제
    @PreAuthorize("principal.username == #vo.replier")
    @DeleteMapping(value = "/{rno}")
    public ResponseEntity<String> delete(@RequestBody ReplyVO vo,
                                         @PathVariable("rno") Long rno) {

        log.info("Delete : " + rno);

        return service.remove(vo.getRno()) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

    }

    // 댓글 수정
    @PreAuthorize("principal.username == #vo.replier")
    @RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
            value = "/{rno}", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {

        vo.setRno(rno);

        log.info("rno : " + rno);
        log.info("modify : " + vo);

        return service.modify(vo) == 1
                ? new ResponseEntity<>("success", HttpStatus.OK)
                : new ResponseEntity<>("error", HttpStatus.INTERNAL_SERVER_ERROR);

    }

}
