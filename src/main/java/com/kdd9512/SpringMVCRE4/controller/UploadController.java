package com.kdd9512.SpringMVCRE4.controller;

import com.kdd9512.SpringMVCRE4.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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

    @PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {

        List<AttachFileDTO> list = new ArrayList<>();
        log.info("Update Ajax POST...........................");
        String uploadFolder = "C:\\JAVA\\galupload";

        // 폴더 생성.
        String uploadFolderPath = getFolder(); // 화면 표시를 위해 보낼 객체에 폴더경로 정보를 저장한다.
        File uploadPath = new File(uploadFolder, uploadFolderPath);
        log.info("Upload Folder : " + uploadPath);

        if (!uploadPath.exists()) {
            uploadPath.mkdirs();
        }

        // 폴더 경로(월/일) 생성.
        for (MultipartFile multipartFile : uploadFile) {

            AttachFileDTO attachDTO = new AttachFileDTO(); // 화면출력을 위한 정보를 담을 객체.

            log.info("-----------------------------------------------------------");
            log.info("Upload File Name : " + multipartFile.getOriginalFilename());
            log.info("Upload File Size : " + multipartFile.getSize());

            String uploadFileName = multipartFile.getOriginalFilename();

            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
            log.info("File Name Only : " + uploadFileName);
            attachDTO.setFileName(uploadFileName);

            // UUID 를 첨부한 파일명으로 중복파일 생성으로 인해 기존 파일이 사라지는 문제를 제거한다.
            UUID uuid = UUID.randomUUID();

            uploadFileName = uuid + "_" + uploadFileName;

            // Thumbnail 생성.
            try {
                File saveFile = new File(uploadPath, uploadFileName);
                multipartFile.transferTo(saveFile);

                attachDTO.setUuid(uuid.toString());
                attachDTO.setUploadPath(uploadFolderPath);

                // 업로드하는 파일이 이미지타입인지 체크
                if (checkImageType(saveFile)) {
                    attachDTO.setImage(true);

                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "th_" + uploadFileName));
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }

                // 화면 출력을 위해 보낼 객체 정보를 저장.
                list.add(attachDTO);

            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]> getFile(String fileName) {

        log.info("fileName : " + fileName);

        File file = new File("C:\\JAVA\\galupload\\" + fileName);
        log.info("file : " + file);

        ResponseEntity<byte[]> result = null;

        try {
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE) // 이 요청만 처리한다.
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent,
                                                 String fileName) {

        log.info("download file : " + fileName);

        FileSystemResource resource = new FileSystemResource("C:\\JAVA\\galupload\\" + fileName);
        log.info("resource : " + resource);

        if (!resource.exists()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        String resourceName = resource.getFilename();
        HttpHeaders headers = new HttpHeaders();

        // 브라우저별로 구분하여 headers 에 삽입한다.
        try {
            String downloadName = null;
            if (userAgent.contains("Trident")) {
                log.info("IE Browser");
                downloadName = URLEncoder.encode(resourceName, "UTF-8").replaceAll("\\+", " ");
            } else if (userAgent.contains("Edge")) {
                log.info("MS Edge");
                downloadName = URLEncoder.encode(resourceName, "UTF-8");
                log.info("Edge Name : " + downloadName);
            } else {
                log.info("Google Chrome");
                downloadName = new String(resourceName.getBytes("UTF-8"), "ISO-8859-1");
            }

            headers.add("Content-Disposition", "attachment; filename=" +
                    downloadName);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return new ResponseEntity<>(resource, headers, HttpStatus.OK);

    }

}
