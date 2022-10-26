<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Title</title>
</head>
<body>
    <h1>/sample/public page</h1>
    <%-- 로그인하지 않은 경우 --%>
    <sec:authorize access="isAnonymous()">
        <a href="/customLogin">로그인</a>
    </sec:authorize>
    <%-- 로그인하여 관리자/매니저/일반 자격을 얻은 경우 --%>
    <sec:authorize access="isAuthenticated()">
        <a href="/customLogout">로그아웃</a>
    </sec:authorize>
</body>
</html>
