package com.kdd9512.SpringMVCRE4.security;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
        "file:src/main/webapp/WEB-INF/root-context.xml",
        "file:src/main/webapp/WEB-INF/security-context.xml"})
@Log4j
public class MemberTests {

    @Setter(onMethod_ = @Autowired)
    private PasswordEncoder pwEncoder;

    @Setter(onMethod_ = @Autowired)
    private DataSource dataSrc;

    @Test
    public void testInsertMember() {

        String sql = "insert into tbl_member(userid, userpw, username) values (?,?,?)";

        for (int i = 0; i < 100; i++) {

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                conn = dataSrc.getConnection();
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(2, pwEncoder.encode("pw" + i)); // 비밀번호 생성 후 encrypt

                if (i < 80) {
                    pstmt.setString(1, "user" + i);
                    pstmt.setString(3, "일반사용자 " + i);
                } else if (i < 90) {
                    pstmt.setString(1, "manager" + i);
                    pstmt.setString(3, "매니저 " + i);
                } else {
                    pstmt.setString(1, "admin" + i);
                    pstmt.setString(3, "관리자 " + i);
                }

                pstmt.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } // for

    }

    @Test
    public void testInsertAuth() {

        String sql = "insert into tbl_member_auth (userid, auth) values (?,?)";

        for (int i = 0; i < 100; i++) {

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {

                conn = dataSrc.getConnection();
                pstmt = conn.prepareStatement(sql);

                if (i < 80) {
                    pstmt.setString(1, "user" + i);
                    pstmt.setString(2, "ROLE_USER");
                } else if (i < 90) {
                    pstmt.setString(1, "manager" + i);
                    pstmt.setString(2, "ROLE_MANAGER");
                } else {
                    pstmt.setString(1, "admin" + i);
                    pstmt.setString(2, "ROLE_ADMIN");
                }

                pstmt.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();

            } finally {
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                if (conn != null) {
                    try {
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

            }

        } // end of for

    }

}
