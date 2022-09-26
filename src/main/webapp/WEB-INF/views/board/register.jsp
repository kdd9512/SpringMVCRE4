<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Tables</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Register Page</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <form role="form" action="/board/register" method="post">
                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name="title">
                    </div>
                    <div class="form-group">
                        <label>Text Area</label>
                        <textarea class="form-control"
                                  rows="3" name="content"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer">
                    </div>
                    <button type="submit" class="btn btn-default">Submit</button>
                    <button type="reset" class="btn btn-default">Clear</button>
                </form>
            </div>
            <%-- panel-body end --%>
        </div>
        <%-- panel-default end --%>
    </div>
    <%-- col-lg-12 end --%>
</div>
<%-- row end --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">File Attach</div>
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
        <%-- panel-default --%>
    </div>
    <%-- col-lg-12 --%>
</div><%-- row --%>
<script>
    $(document).ready(function (e) {

        let formObj = $("form[role='form']");

        $("button[type='submit']").on("click", function (e) {
            e.preventDefault();
            console.log("clicked")
        });

        let str = "";

        $(".uploadResult ul li").each(function (i, obj) {

            let jobj = $(obj);
            console.dir(jobj);

            // BoardVO 가 수집한 첨부파일의 정보의 일부를 이하 hidden 태그에 담아 jsp 에서 활용한다.
            str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("fileName") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("uploadPath") + "'>";
            str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("fileType") + "'>";

            formObj.append(str).submit();

        });

        let regex = new RegExp("(.*?)\.(exe|sh|zip|alz|rar)$");
        let maxSize = 5242880; // 5MB
        let cloneObj = $(".uploadDiv").clone();

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
                    alert("uploaded " + result);

                    // upload 한 파일의 이름을 화면에 출력한다.
                    showUploadResult(result);

                    // upload 이후 input 을 초기화한다.
                    $(".uploadDiv").html(cloneObj.html());
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

                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " +
                        "data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>" +
                        "<span> " + obj.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>" +
                        "<img src='/display?fileName=" + fileCallPath + "'>" +
                        "</div></li>";
                } else {
                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/th_" + obj.uuid + "_" + obj.fileName);
                    let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
                    // let originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
                    // originPath = originPath.replace(new RegExp(/\\/g), "/");

                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " +
                        "data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>" +
                        "<span> " + obj.fileName + "</span>" +
                        "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' " +
                        "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button<br>" +
                        "<img src='/resources/img/attach.png'></a>" +
                        "</div></li>";
                }
                uploadUL.append(str);
            });


        }

        $(".uploadResult").on("click", "button", function (e) {

            let targetFile = $(this).data("file");
            let type = $(this).data("type");
            let targetLi = $(this).closest("li");
            console.log("delete this : " + targetFile);

            $.ajax({
                url: '/deleteFile',
                data: ({fileName: targetFile, type: type}),
                dataType: "text",
                type: 'POST',
                success: function (result) {
                    alert(result);
                    targetLi.remove();
                }
            });
        });

    });
</script>

<%@ include file="../includes/footer.jsp" %>