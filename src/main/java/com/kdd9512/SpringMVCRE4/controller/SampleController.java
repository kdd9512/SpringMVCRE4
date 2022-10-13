package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Log4j
@RequestMapping(value = "/sample/")
@Controller
public class SampleController {

    @GetMapping("/public")
    public void doPublic() {
        log.info("public page. can access anybody");
    }

    @GetMapping("/member")
    public void doMember() {
        log.info("only logged in member");

    }

    @GetMapping("/admin")
    public void doAdmin() {
        log.info("admin only page");

    }


}
