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
public class SampleServiceTests {

    @Setter(onMethod_ = {@Autowired})
    private SampleService service;

    @Test
    public void testClass() {
        log.info(service);
        log.info(service.getClass().getName());
    }

    @Test
    public void testAdd() {

        try {
            log.info(service.doAdd("123","234"));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Test
    public void testAddErr() {

        try {
            log.info(service.doAdd("123","asdf"));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
