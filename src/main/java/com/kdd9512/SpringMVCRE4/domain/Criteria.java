package com.kdd9512.SpringMVCRE4.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.util.UriComponentsBuilder;


@Getter
@Setter
@ToString
public class Criteria { // 검색의 기준을 설정하기 위한 클래스.

    private int pageNum;
    private int amount;

    private String type;
    private String keyword;

    public Criteria() {
        this(1,10);
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }

    public String[] getTypeArr() {

        return type == null ? new String[] {} : type.split("");

    }

    // 22.08.05 UriComponentsBuilder 사용하여 필요한 param 을 추가.
    // 이 부분 복습 필요.....
    public String getListLink() {
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("pageNum", this.getPageNum())
                .queryParam("amount", this.getAmount())
                .queryParam("keyword", this.getKeyword())
                .queryParam("type", this.getType());

        return builder.toUriString();

    }

}
