package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;

@Controller
@Log4j
public class UploadController {

    // JSP 불러오기 용도.
    @GetMapping("/uploadForm")
    public void uploadForm() {
        log.info("Upload Form");
    }

    @GetMapping("/uploadAjax")
    public void uploadAjax() {
        log.info("Upload Ajax");
    }


    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model) {

        String uploadFolder = "C:\\JAVA\\galupload";

        for (MultipartFile multipartFile : uploadFile) {

            log.info("======================================================================================");
            log.info("Uploaded File Name : " + multipartFile.getOriginalFilename());
            log.info("Uploaded File Size : " + multipartFile.getSize());
            log.info("======================================================================================");

            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

            try {
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }

        }

    }

    @PostMapping("/uploadAjaxAction")
    public void uploadAjaxPost(MultipartFile[] uploadFile) {

        log.info("Update Ajax POST...........................");
        String uploadFolder = "C:\\JAVA\\galupload";

        for (MultipartFile multipartFile : uploadFile) {

            log.info("-----------------------------------------------------------");
            log.info("Upload File Name : " + multipartFile.getOriginalFilename());
            log.info("Upload File Size : " + multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
            log.info("File Name Only" + uploadFileName);

            File saveFile = new File(uploadFolder, uploadFileName);

            try {
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }

        }

    }



}
