package com.kdd9512.SpringMVCRE4.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

    private int startPage; // 시작페이지
    private int endPage; // 끝페이지
    private boolean prev, next;

    private int total; // 전체 데이터 개수
    private com.kdd9512.SpringMVCRE4.domain.Criteria cri;

    public PageDTO(com.kdd9512.SpringMVCRE4.domain.Criteria cri, int total) {
        this.cri = cri;
        this.total = total;

        // 페이지 끝 번호를 구한다.
        // Math.ceil은 안의 숫자를 무조건 올림한다.
        // ex : Math.ceil(10 / 10.0 => 1) * 10 = 10
        //      Math.ceil(10 / 11.0 => 1.1 => 2) * 10 = 20
        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
        this.startPage = this.endPage -9; // 페이지 시작 번호

        int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount())); // 전체 데이터 수에 따라 진짜 끝페이지의 수를 구함.

        // 만약 끝페이지가 위에서 구한 페이지 보다 크다면 끝페이지는 realEnd 값이 되어야 한다.
        // ex : 페이지 당 10개의 데이터를 출력하려고 하며 총 데이터가 80개라면 페이지 개수는 8개가 될 것.
        // 만약 endPage * 한페이지당 출력데이터수 의 값이 total 보다 크면 재계산.
        if (realEnd < this.endPage) {
            this.endPage = realEnd;
        }

        // 이전페이지는 시작번호가 1보다 크면 존재.
        this.prev = this.startPage > 1;
        // 다음페이지는 realEnd 가 endPage 보다 큰 경우에만 존재.
        this.next = this.endPage < realEnd;

    }
}
