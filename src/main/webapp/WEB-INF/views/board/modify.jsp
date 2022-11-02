<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../includes/header.jsp" %>

<style type="text/css">

    .uploadResult {
        width: 100%;
        background-color: gray;
    }

    .uploadResult ul {
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }

    .uploadResult ul li {
        list-style: none;
        padding: 10px;
    }

    .uploadResult ul li img {
        width: 50%;
    }

    .uploadResult ul li span {
        color: white;
    }

    .bigPictureWrapper {
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: gray;
        z-index: 100;
        background: rgba(255, 255, 255, 0.5);
    }

    .bigPicture {
        position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .bigPicture img {
        width: 600px;
    }

</style>
<%-- style end --%>

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
                    <%-- CSRF token : Spring Security 를 사용하고 POST 방식으로 전송할 시 반드시 추가해야 한다. --%>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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

                    <%-- 현재 로그인한 사용자가 글의 작성자인 경우에만 보이도록 수정. --%>
                    <sec:authentication property="principal" var="pinfo"/>
                    <sec:authorize access="isAuthenticated()">
                        <c:if test="${pinfo.username eq board.writer}">
                            <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                            <button type="submit" data-oper="remove" class="btn btn-danger">DELETE</button>
                        </c:if>
                    </sec:authorize>

                    <button type="submit" data-oper="list" class="btn btn-info">List</button>

                </form>
            </div>
        </div>
    </div>
</div>

<div class="bigPictureWrapper">
    <div class="bigPicture"></div>
</div>

<%-- File area start --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name="uploadFile" multiple>
                </div>
                <%-- uploadDiv --%>
                <div class="uploadResult">
                    <ul>
                    </ul>
                </div>
                <%-- uploadResult --%>
            </div>
            <%-- panel-body --%>
        </div>
        <%--panel--%>
    </div>
    <%-- col --%>
</div><%-- Files row end  --%>

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

                case 'modify': { // 게시물 수정
                    console.log("SUBMIT ACTIVATED");
                    let str = "";

                    $(".uploadResult ul li").each(function (i, obj) {

                        let jobj = $(obj);
                        console.dir(jobj);

                        // BoardVO 가 수집한 첨부파일의 정보의 일부를 이하 hidden 태그에 담아 jsp 에서 활용한다.
                        str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
                        str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
                        str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
                        str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
                    });
                    // formObj.attr("action", "/board/modify").submit();
                    formObj.append(str).submit();
                    break;
                }
                case 'remove': { // 게시물 삭제
                    formObj.attr("action", "/board/remove");

                    break;
                }
                case 'list': { // 게시물 표시
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
<script>
    $(document).ready(function () {

        let bno = "<c:out value="${board.bno}"/>";

        $.getJSON("/board/getAttachList", {bno: bno}, function (arr) {
            console.log(arr);

            let str = "";

            $(arr).each(function (i, attach) {

                if (attach.fileType) {
                    let fileCallPath = encodeURIComponent(attach.uploadPath + "/th_" + attach.uuid + "_" + attach.fileName);

                    str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' " +
                        "data-filename='" + attach.fileName + "' data-type='" + attach.image + "'><div>" +
                        "<span>" + attach.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>" +
                        "<img src='/display?fileName=" + fileCallPath + "'>" +
                        "</div></li>";
                } else {
                    let fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
                    let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
                    // let originPath = attach.uploadPath + "\\" + attach.uuid + "_" + attach.fileName;
                    // originPath = originPath.replace(new RegExp(/\\/g), "/");

                    str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' " +
                        "data-filename='" + attach.fileName + "' data-type='" + attach.image + "'><div>" +
                        "<span> " + attach.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button<br>" +
                        "<img src='/resources/img/attach.png'></a>" +
                        "</div></li>";

                }

            });
            $(".uploadResult ul").html(str);
        }); // getJSON end.

        $(".uploadResult").on("click", "li", function (e) {

            console.log("view original image");

            let liObj = $(this);

            let path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));

            if (liObj.data("type")) {
                showImage(path.replace(new RegExp(/\\/g), "/"));
            } else {
                self.location = "/download?fileName=" + path
            }

        });

        function showImage(fileCallPath) {
            // alert(encodeURI(fileCallPath));
            $(".bigPictureWrapper").css("display", "flex").show();
            $(".bigPicture")
                .html("<img src='/display?fileName=" + fileCallPath + "'>")
                .animate({width: '100%', height: '100%'}, 1000);
        }

        $(".bigPictureWrapper").on("click", function (e) {
            $('.bigPicture').animate({width: '0%', height: '0%'}, 1000);
            setTimeout(() => {
                $(this).hide();
            }, 1000);
        });

        $(".uploadResult").on("click", "button", function (e) {

            let targetFile = $(this).data("file");
            let type = $(this).data("type");
            let targetLi = $(this).closest("li");

            if (confirm("Are you sure you want to delete this file?")) {

                console.log("delete this : " + targetFile);

                $.ajax({
                    url: '/deleteFile',
                    data: ({fileName: targetFile, type: type}),
                    dataType: "text",
                    type: 'POST',
                    success: function (result) {
                        targetLi.remove();
                    }
                });

            }
        });

        // 파일 업로드
        let regex = new RegExp("(.*?)\.(exe|sh|zip|alz|rar)$");
        let maxSize = 5242880; // 5MB

        function checkExtension(fileName, fileSize) {

            if (fileSize >= maxSize) {
                alert("파일의 용량이 너무 큽니다(최대 5MB)");
                return false;
            }

            if (regex.test(fileName)) {
                alert("해당 종류의 파일은 업로드할 수 없습니다.");
                return false;
            }

            return true;
        } // checkExtension

        $("input[type='file']").change(function (e) {

            let formData = new FormData();
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;

            for (let i = 0; i < files.length; i++) {

                if (!checkExtension(files[i].name, files[i].size)) {
                    return false;
                }
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: "/uploadAjaxAction",
                processData: false,
                contentType: false,
                data: formData,
                type: "POST",
                dataType: "JSON",
                success: function (result) {
                    // upload 한 파일의 이름을 화면에 출력한다.
                    showUploadResult(result);

                }
            }); // ajax

        });

        function showUploadResult(uploadResultArr) {
            if (!uploadResultArr || uploadResultArr.length == 0) {
                return;
            }

            let uploadUL = $(".uploadResult ul");
            let str = "";

            $(uploadResultArr).each(function (i, obj) {
                if (obj.image) {

                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/th_" + obj.uuid + "_" + obj.fileName);

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " +
                        "data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>" +
                        "<span>" + obj.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>" +
                        "<img src='/display?fileName=" + fileCallPath + "'>" +
                        "</div></li>";
                } else {
                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                    let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
                    // let originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
                    // originPath = originPath.replace(new RegExp(/\\/g), "/");

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " +
                        "data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>" +
                        "<span> " + obj.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button<br>" +
                        "<img src='/resources/img/attach.png'></a>" +
                        "</div></li>";
                }
            });
            uploadUL.append(str);
        };
        // 파일 업로드 끝


    });

</script>

<%@ include file="../includes/footer.jsp" %>

