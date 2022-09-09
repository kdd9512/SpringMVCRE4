<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Title</title>
</head>
<body>
<h1>Upload With AJAX</h1>
<div class="uploadDiv">
    <input type="file" name='uploadFile' multiple>
</div>
<button id="uploadBtn">UPLOAD</button>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {

        let regex = new RegExp("(.*?)\.(exe|sh|zip|alz|rar|)$");
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

        $("#uploadBtn").on("click", function(e) {
            let formData = new FormData();
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;
            console.log(files);

            for(let i = 0; i < files.length; i++) {

                if (!checkExtension(files[i].name, files[i].size)) {
                    return false;
                }
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url : "/uploadAjaxAction",
                processData : false,
                contentType : false,
                data : formData,
                type : "POST",
                success : function (result) {
                    alert("uploaded");
                }
            }); // ajax

        }); // .on("click")

    });// .ready(function () { ... })
</script>

</body>
</html>
