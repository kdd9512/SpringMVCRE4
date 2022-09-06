package com.kdd9512.SpringMVCRE4.service;

import com.kdd9512.SpringMVCRE4.mapper.Sample1Mapper;
import com.kdd9512.SpringMVCRE4.mapper.Sample2Mapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Log4j
public class SampleTxServiceImpl implements SampleTxService{

    @Setter(onMethod_ = {@Autowired})
    private Sample1Mapper mapper1;

    @Setter(onMethod_ = {@Autowired})
    private Sample2Mapper mapper2;


    @Transactional // 트랜잭션 설정. 한 가지 이상의 작업을 묶어서 실행하며, 한 작업이라도 fail 하면 트랜잭션으로 묶인 작업 전체가 fail.
    @Override
    public void addData(String value) {

        log.info("mapper1=======================================");
        mapper1.insertCol1(value);

        log.info("mapper2=======================================");
        mapper2.insertCol2(value);

        log.info("ADD============================================");

    }
}
