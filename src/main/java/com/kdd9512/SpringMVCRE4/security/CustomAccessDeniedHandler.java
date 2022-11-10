package com.kdd9512.SpringMVCRE4.security;

import lombok.extern.log4j.Log4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Log4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {


    @Override
    public void handle(
            HttpServletRequest request, HttpServletResponse resp,
            AccessDeniedException accessDeniedException) throws IOException, ServletException {

        log.error("Access Denied handler started.......");
        log.error("ERROR : " + accessDeniedException);
        log.error("Redirected........");


        resp.sendRedirect("/accessError");
    }
}
