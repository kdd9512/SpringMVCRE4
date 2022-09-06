package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j
public class MainController {

    @GetMapping("/")
    public String main() {
        log.info("==================[START]=====================");

        return "redirect:/board/list";
    }
}
