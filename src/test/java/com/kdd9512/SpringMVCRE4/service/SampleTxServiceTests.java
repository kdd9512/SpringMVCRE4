package com.kdd9512.SpringMVCRE4.service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/root-context.xml"})
public class SampleTxServiceTests {

    @Setter(onMethod_ = {@Autowired})
    private SampleTxService service;

    // 50 byte 이상 500 bytes 이하의 String 을 넣고 insert 를 시도
    // tbl_sample1 은 컬럼이 500byte, tbl_sample2 는 50byte 이므로 하나는 무조건 실패하는게 정상.
    @Test
    public void testLong(){

        // 82byte
        String str = "Starry\r\n" +
                "Starry night\r\n" +
                "Paint your palette blue and gray\r\n" +
                "Look out on a summer's day";

        log.info(str.getBytes().length);

        service.addData(str);

    }

}
