<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Modify</h1>
    </div>
</div>
<%--/.row--%>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Modify Page</div>
            <div class="panel-body">

                <form role="form" action="/board/modify" method="post">

                    <input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum}"/>">
                    <input type="hidden" name="amount" value="<c:out value="${cri.amount}"/>">
                    <%-- Criteria 에서 가져온 type / keyword 를 param 으로 추가.
                        검색결과를 냈던 list 로 되돌아가기 위함--%>
                    <input type="hidden" name="keyword" value="<c:out value="${cri.keyword}"/>">
                    <input type="hidden" name="type" value="<c:out value="${cri.type}"/>">

                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name="bno" value="<c:out value="${board.bno}"/>"
                               readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name="title" value="<c:out value="${board.title}"/>">
                    </div>

                    <div class="form-group">
                        <label>Text Area</label>
                        <textarea class="form-control" rows="3" name="content">
                            <c:out value="${board.content}"/>
                        </textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer" value="<c:out value="${board.writer}"/>"
                               readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>RegDate</label>
                        <input class="form-control" name="regdate" pattern="yyyy/MM/dd"
                               value="<fmt:formatDate value="${board.regDate}"/>" readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Update Date</label>
                        <input class="form-control" name="updatedate" pattern="yyyy/MM/dd"
                               value="<fmt:formatDate value="${board.updateDate}"/>" readonly="readonly">
                    </div>

                    <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                    <button type="submit" data-oper="remove" class="btn btn-danger">DELETE</button>
                    <button type="submit" data-oper="list" class="btn btn-info">List</button>

                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {

        let formObj = $("form");

        $('button').on('click', function (e) {

            e.preventDefault();
            // data-oper 선택.
            let operation = $(this).data('oper');

            console.log("operation : [ " + operation + " ]");


            // data-oper 의 값에 따라 기능을 실행한다.
            switch (operation) {
                case 'modify': {
                    formObj.attr("action", "/board/modify").submit();

                    break;
                }
                case 'remove': {
                    formObj.attr("action", "/board/remove");

                    break;
                }
                case 'list': {
                    formObj.attr("action", "/board/list").attr("method", "GET"); // move to list

                    let pageNumTag = $("input[name='pageNum']").clone();
                    let amountTag = $("input[name='amount']").clone();
                    let keywordTag = $("input[name='keyword']").clone();
                    let typeTag = $("input[name='type']").clone();
                    // Criteria 에서 넘어온 param 인 keyword 와 type 을 추가한다.
                    // 이 param 을 이용하여 검색결과가 나왔었던 list 로 돌아갈 수 있음.
                    formObj.empty();
                    formObj.append(pageNumTag);
                    formObj.append(amountTag);
                    formObj.append(keywordTag);
                    formObj.append(typeTag);

                    break;
                }

            }
            formObj.submit();

        });

    });
</script>

<%@ include file="../includes/footer.jsp" %>

