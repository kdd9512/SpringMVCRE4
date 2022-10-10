package com.kdd9512.SpringMVCRE4.task;

import com.kdd9512.SpringMVCRE4.domain.BoardAttachVO;
import com.kdd9512.SpringMVCRE4.mapper.BoardAttachMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {

    @Setter(onMethod_ = {@Autowired})
    private BoardAttachMapper attachMapper;

    private String getFolderYesterday() {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1); //

        String str = sdf.format(cal.getTime());

        return str.replace("-", File.separator);
    }

    /** 크론 설정
     * 표현식의 일종
     * 왼쪽부터 초, 분, 시, 일, 월, 요일(0 : 일요, 1 : 월요 ... ), 년(선택사항)
     *
     * 기호의 종류 :
     * "*" 모든 수
     * "?" 제외
     * "-" 기간
     * "," 특정시간
     * "/" 시작 시간과 반복시간
     * "L" 마지막
     * "W" 가까운 평일
     * **/
    @Scheduled(cron = "0 0 2 * * *") // 새벽 2시에 이하의 메서드가 동작한다.
    public void checkFiles() throws Exception {
        log.warn("File Check Task is running....................");
        log.warn(new Date());
        List<BoardAttachVO> fileList = attachMapper.getOldFiles(); // 어제 업로드된 모든 첨부파일의 목록을 가져옴.

        // fileList 는 BoardAttachVO 타입이므로 이하에서 Paths 목록으로 변환시킨다.
        // 아직은 실제 존재유무를 알 수 없으므로 예상목록인 fileListPaths 를 생성.
        List<Path> fileListPaths = fileList.stream()
                .map(vo -> Paths.get("C:\\JAVA\\galupload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
                .collect(Collectors.toList());

        // 이미지파일일 경우 섬네일 파일도 존재할 것이므로 여기서 Paths 목록으로 변환.
        fileList.stream().filter(vo -> vo.isFileType() == true)
                .map(vo -> Paths.get("C:\\JAVA\\galupload", vo.getUploadPath(), "th_" + vo.getUuid() + "_" + vo.getFileName()))
                .forEach(path -> fileListPaths.add(path));

        log.warn("=======================================================");

        fileListPaths.forEach(path -> log.warn("PATH : " + path));

        // 실제 폴더 내에 파일이 존재하는가를 확인하기 위한 경로설정.
        File targetDir = Paths.get("C:\\JAVA\\galupload", getFolderYesterday()).toFile();
        // 예상목록인 fileListPaths 와 비교하여 없는 파일의 목록을 담는다.
        File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
        log.warn("=======================================================");

        // 없는 파일 목록인 removeFiles 를 기준으로 삭제를 실시한다.
        for (File file : removeFiles) {

            log.warn(file.getAbsolutePath());

            file.delete();

        }

    }

}
