package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

@Controller
@Log4j
public class UploadController {

    // JSP 불러오기 용도.
    @GetMapping("/uploadForm")
    public void uploadForm() {

        log.info("Upload Form");

    }


    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model) {

        for (MultipartFile multipartFile : uploadFile) {

            log.info("======================================================================================");
            log.info("Uploaded File Name : " + multipartFile.getOriginalFilename());
            log.info("Uploaded File Size : " + multipartFile.getSize());
            log.info("======================================================================================");

        }

    }

}
