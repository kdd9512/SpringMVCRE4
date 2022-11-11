package com.kdd9512.SpringMVCRE4.controller;

import com.kdd9512.SpringMVCRE4.domain.*;
import com.kdd9512.SpringMVCRE4.service.BoardService;
import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

    private final BoardService service;

//    @GetMapping("/list")
//    public void list(Model model) {
//        log.info("list==================================");
//
//        model.addAttribute("list", service.getList());
//    }

    @GetMapping("/list")
    public void list(Criteria cri, Model model) {
        log.info("list =============[ " + cri + " ]================");

        model.addAttribute("list", service.getList(cri));
//        model.addAttribute("pageMaker", new PageDTO(cri, 123)); 임시로 페이지 수 설정.

        int total = service.getTotal(cri); // 총 페이지수를 구한다.
        log.info("Total: " + total);

        model.addAttribute("pageMaker", new PageDTO(cri, total));
    }

    @GetMapping("/register")
    @PreAuthorize("isAuthenticated()") // 로그인에 성공한 사용자만 사용할 수 있도록 설정
    public void register() {
    }

    @PostMapping("/register")
    @PreAuthorize("isAuthenticated()") // 로그인에 성공한 사용자만 사용할 수 있도록 설정
    public String register(BoardVO board, RedirectAttributes attributes) {
        log.info("====================================================================");
        log.info(("register : [ " + board + " ]"));

        if (board.getAttachList() != null) {
            // board.getAttachList().forEach(attach -> log.info(attach));
            board.getAttachList().forEach(log::info);
        }

        log.info("====================================================================");
        service.register(board);

        attributes.addFlashAttribute("result", board.getBno());

        return "redirect:/board/list";

    }

    @GetMapping({"/get", "/modify"})
    public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri,
                    Model model) {
        log.info("================================/get or /modify========================================");
        model.addAttribute("board", service.get(bno));

    }

    @PreAuthorize("principal.username == #board.writer") // 현재 수정을 시도하려는 사용자가 해당 글의 작성자와 같은지를 확인.
    @PostMapping("/modify") // 글을 수정 / 삭제하기 위해서는 뭔가 양식을 보내야 하므로 PostMapping 이 필요.
    public String modify(BoardVO board, RedirectAttributes attributes,
                         Criteria cri) {
        // 더 이상 ModelAttribute 에 담아 param 을 전달할 필요가 없다. 해당 기능은 getListLink(); 가 대신함.
//                         @ModelAttribute("cri") Criteria cri) {
        log.info("modified : [ " + board + " ]");

        if (service.modify(board)) {
            attributes.addFlashAttribute("result", "success");
        }
//          getListLink(); 가 이를 대신 수행한다.
//        attributes.addAttribute("pageNum", cri.getPageNum());
//        attributes.addAttribute("amount", cri.getAmount());

        return "redirect:/board/list" + cri.getListLink();
    }

    @PreAuthorize("principal.username == #writer") // 현재 삭제를 시도하려는 사용자가 해당 글의 작성자와 같은지를 확인.
    @PostMapping("/remove") // 작업 후 redirect 해야하므로 RedirectAttributes
    public String remove(@RequestParam("bno") Long bno, RedirectAttributes attributes,
                         Criteria cri, String writer) {
        // 더 이상 ModelAttribute 에 담아 param 을 전달할 필요가 없다. 해당 기능은 getListLink(); 가 대신함.
//                         @ModelAttribute("cri") Criteria cri) {
        log.info("removed : [ " + bno + " ]");

        List<BoardAttachVO> attachList = service.getAttachList(bno);

        if (service.remove(bno)) {
            deleteAllFiles(attachList);

            attributes.addFlashAttribute("result", "success");
        }
        //          getListLink(); 가 이를 대신 수행한다.
//        attributes.addAttribute("pageNum", cri.getPageNum());
//        attributes.addAttribute("amount", cri.getAmount());

        return "redirect:/board/list" + cri.getListLink();
    }


    // 특정 게시물 번호를 이용하여 해당 글의 첨부파일 정보를 JSON 으로 반환한다.
    @GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {

        log.info("getAttachList : " + bno);

        return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
    }


    private void deleteAllFiles(List<BoardAttachVO> attachList) {

        if (attachList == null || attachList.size() == 0) {
            return;
        }

        attachList.forEach(attach -> {
            try {
                Path file = Paths.get("C:\\JAVA\\galupload" +
                        attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
                Files.deleteIfExists(file);

                if(Files.probeContentType(file).startsWith("image")) {

                    Path thumbNail = Paths.get("C:\\JAVA\\galupload" +
                            attach.getUploadPath() + "\\th_" + attach.getUuid() + "_" + attach.getFileName());
                    Files.delete(thumbNail);
                }

            } catch(Exception e) {
                log.error("Delete File Error : " + e.getMessage());
            }

        });

    }

}
