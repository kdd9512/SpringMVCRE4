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
    <h1>/sample/admin page</h1>

    <%-- spring security 관련정보를 출력하기 위해 할 것.
     1. taglib 으로 http://www.springframework.org/security/tags 을 호출. prefix 는 sec
     2. <sec:authentication /> 태그, principal 이라는 property 를 사용 --%>
    <p>principal : <sec:authentication property="principal"/></p>
    <p>MemberVO : <sec:authentication property="principal.member"/></p>
    <p>사용자 : <sec:authentication property="principal.member.userName"/></p>
    <p>사용자ID : <sec:authentication property="principal.username"/></p>
    <p>사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/></p>

    <a href="/customLogout">LOGOUT</a>
</body>
</html>
