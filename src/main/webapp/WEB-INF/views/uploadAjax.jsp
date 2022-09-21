<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Title</title>
</head>
<body>
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
        width: 10%;
    }

    .uploadResult ul li span {
        color:white;
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
<h1>Upload With AJAX</h1>
<div class="uploadDiv">
    <input type="file" name='uploadFile' multiple>
</div>
<button id="uploadBtn">UPLOAD</button>

<%-- 파일 미리보기 --%>
<div class="uploadResult">
    <ul>
    </ul>
</div>

<%-- 원본그림 보기. --%>
<div class="bigPictureWrapper">
    <div class="bigPicture">
    </div>
</div>


<script type="text/javascript"
        src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
<script type="text/javascript">


    function showImage(fileCallPath) {
        // alert(encodeURI(fileCallPath));
        $(".bigPictureWrapper").css("display", "flex").show();
        $(".bigPicture")
            .html("<img src='/display?fileName=" + encodeURI(fileCallPath)+"'>")
            .animate({width: '100%', height: '100%'}, 1000);
    }

    $(".bigPictureWrapper").on("click", function(e){
        $('.bigPicture').animate({width: '0%', height: '0%'}, 1000);
        setTimeout(() => {
            $(this).hide();
        }, 1000);
        // IE11 용. IE 는 arrow function 이 동작하지 않는다.
        /*setTimeout(function(){
            $('.bigPicture').hide();
        }, 1000);*/

    })

    $(document).ready(function () {

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

        // 업로드 부분 초기화를 위하여 아무 파일도 첨부되지 않은 <input type="file" ... > 을 복사.
        let cloneObj = $(".uploadDiv").clone();

        $("#uploadBtn").on("click", function (e) {
            let formData = new FormData();
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;
            console.log(files);

            // 업로드할 파일이 없는 경우에도 upload 가 진행되어 500 error 를 발생시킨다.
            if (files.length == 0) {
                alert("업로드할 파일이 없습니다...");
                return false;
            }

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
                    // alert("uploaded " + result);

                    // upload 한 파일의 이름을 화면에 출력한다.
                    showUploadedFile(result);

                    // upload 이후 input 을 초기화한다.
                    $(".uploadDiv").html(cloneObj.html());

                }
            }); // ajax

        }); // .on("click")

        let uploadResult = $(".uploadResult ul");

        function showUploadedFile(uploadResultArr) {
            let str = "";
            // 이미지파일이 아니라면(=일반파일이라면) 이름과 파일이미지를 표시하게 조치.
            // 이미지파일이라면 섬네일을 표시.
            $(uploadResultArr).each(function (i, obj) {
                if (!obj.image) {

                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                    let fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

                    str += "<li><div><a href='/download?fileName=" + fileCallPath + "'>" +
                        "<img src='/resources/img/attach.png'>" + obj.fileName + "</a>" +
                        "<span data-file=\'"+ fileCallPath + "\' data-type='file'>&nbsp;&times;</span>" +
                        "</div></li>";
                } else {
                    let fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                    let originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
                    originPath = originPath.replace(new RegExp(/\\/g), "/");

                    console.log("fileCallPath : " + fileCallPath);
                    console.log("originPath : " + originPath);
                    str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">" +
                        // "<a href='/download?fileName=" + fileCallPath + "'/>" +
                        "<img src='/display?fileName=" + fileCallPath + "'/></a>" +
                        "<span data-file=\'"+ fileCallPath + "\' data-type='file'>&nbsp;&times;</span>" +
                        "</li>";
                }
            });
            uploadResult.append(str);
        }

        $(".uploadResult").on("click","span",function(e) {

            let targetFile = $(this).data("file");
            let type = $(this).data("type");
            console.log(targetFile);

            $.ajax({
                url: '/deleteFile',
                data: ({fileName : targetFile, type : type}),
                dataType: "text",
                type: 'POST',
                success: function(result) {
                    alert(result);
                }
            });
        });

    });// .ready(function () { ... })
</script>

</body>
</html>
