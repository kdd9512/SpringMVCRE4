package com.kdd9512.SpringMVCRE4.task;

import lombok.extern.log4j.Log4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Log4j
@Component
public class FileCheckTask {
    @Scheduled(cron = "0 * * * * *")
    public void checkFiles() throws Exception {
        log.warn("File Check Task is running....................");

        log.warn("=======================================================");
    }

}
