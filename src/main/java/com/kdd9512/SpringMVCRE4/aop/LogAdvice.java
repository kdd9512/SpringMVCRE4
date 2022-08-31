package com.kdd9512.SpringMVCRE4.aop;

import org.aspectj.lang.annotation.Aspect;
import lombok.extern.log4j.Log4j;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Aspect
@Log4j
@Component
public class LogAdvice {

    /** AspectJ 의 표현식(execution).
     * 접근 제한자와 특정 클래스의 method 를 지정한다.
     * "*" 는 접근제한자.
     * SampleService*.*(..) -> 이름이 SampleService 로 시작하는 service 폴더 내의 모든 클래스의 메서드를 지정.
     * **/
    @Before( "execution(* com.kdd9512.SpringMVCRE4.service.SampleService*.*(..))")
    public void logBefore() {

        log.info("==================================================");

    }
}
