package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j
public class CommonController {


    @GetMapping("/accessError")
    public void accessDenied(Authentication auth, Model model) {
        log.info("Access Denied : " + auth);
        model.addAttribute("msg", "Access Denied");
    }

    @GetMapping("/customLogin")
    public void loginInput(String error, String logout, Model model) {

        log.info("error : "  + error);
        log.info("logout : " + logout);

        if (error != null) {
            model.addAttribute("error", error);
        }

        if (logout != null) {
            model.addAttribute("logout",logout);

        }
    }

}
