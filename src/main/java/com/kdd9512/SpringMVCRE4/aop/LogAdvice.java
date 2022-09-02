package com.kdd9512.SpringMVCRE4.aop;

import org.aspectj.lang.annotation.AfterThrowing;
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

    // @Before 로 어떠한 위치와 조건을 지정하고 해당하는 모든 메서드에 이하를 적용함.
    // 인터셉터와 비슷한 용도로 사용 가능함.
    // 특정 메서드를 지정, 해당 메서드에 들어갈 param 값의 자료형과 param 의 이름을 따로 분리하여 입력한다.
    // && args 이하에 param 의 이름을 넣음.
    @Before("execution(* com.kdd9512.SpringMVCRE4.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
    public void logBeforeWithParam(String str1, String str2) {

        log.info("str1 : " + str1);
        log.info("str2 : " + str2);

    }


    @AfterThrowing(pointcut = "execution(* com.kdd9512.SpringMVCRE4.service.SampleService*.*(..))", throwing = "e")
    public void logException(Exception e) {

        log.info("EXCEPTION TEST..........");
        log.info("EXCEPTION : " + e);
    }
}
