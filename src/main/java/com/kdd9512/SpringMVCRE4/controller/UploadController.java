package com.kdd9512.SpringMVCRE4.controller;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
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
    private String getFolder() {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);

        return str.replace("-", File.separator);

    }

    // 이미지 파일인지 구분하기 위한 method
    private boolean checkImageType(File file) {
        try {
            String contentType = Files.probeContentType(file.toPath());

            return contentType.startsWith("image");

        } catch (IOException e) {
            e.printStackTrace();
        }

        return false;
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

        // 폴더 생성.
        File uploadPath = new File(uploadFolder, getFolder());
        log.info("Upload Folder : " + uploadPath);

        if (!uploadPath.exists()) {
            uploadPath.mkdirs();
        }

        // 폴더 경로(월/일) 생성.
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

            // Thumbnail 생성.
            try {
                File saveFile = new File(uploadPath, uploadFileName);
                multipartFile.transferTo(saveFile);

                // 업로드하는 파일이 이미지타입인지 체크
                if (checkImageType(saveFile)) {
                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "th_" + uploadFileName));
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

    }


}
