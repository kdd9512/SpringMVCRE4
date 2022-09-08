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

        $("#uploadBtn").on("click", function(e) {
            let formData = new FormData();
            let inputFile = $("input[name='uploadFile']");
            let files = inputFile[0].files;
            console.log(files);

            for(let i = 0; i <files.length; i++) {
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
