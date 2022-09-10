package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

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

    // 경로 생성을 위한 method
    private String getFolder(){

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);

        return str.replace("-", File.separator);

    }

    // POST 기능
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

        File uploadPath = new File(uploadFolder, getFolder());
        log.info("Upload Folder : " + uploadPath);

        if (!uploadPath.exists()) {
            uploadPath.mkdirs();
        }

        for (MultipartFile multipartFile : uploadFile) {

            log.info("-----------------------------------------------------------");
            log.info("Upload File Name : " + multipartFile.getOriginalFilename());
            log.info("Upload File Size : " + multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
            log.info("File Name Only : " + uploadFileName);

            // UUID 를 첨부한 파일명으로 중복파일 생성으로 인해 기존 파일이 사라지는 문제를 제거한다.
            UUID uuid = UUID.randomUUID();

            uploadFileName = uuid + "_" + uploadFileName;

//            File saveFile = new File(uploadFolder, uploadFileName);
            File saveFile = new File(uploadPath, uploadFileName);

            try {
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }

        }

    }



}
