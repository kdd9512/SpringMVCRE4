<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
</div>
<%--/.row--%>

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
        <div class="panel panel-default">

            <div class="panel-heading">Board Read Page</div>
            <div class="panel-body">

                <div class="form-group">
                    <label>Bno</label>
                    <input class="form-control" name="bno"
                           value="<c:out value="${board.bno}"/>" readonly="readonly">
                </div>

                <div class="form-group">
                    <label>Title</label>
                    <input class="form-control" name="title"
                           value="<c:out value="${board.title}" />" readonly="readonly">
                </div>

                <div class="form-group">
                    <label>Text Area</label>
                    <input class="form-control" name="content"
                           value="<c:out value="${board.content}" />" readonly="readonly">
                </div>

                <div class="form-group">
                    <label>Writer</label>
                    <input class="form-control" name="writer"
                           value="<c:out value="${board.writer}" />" readonly="readonly">
                </div>

                <%-- ?????? ????????? ????????? ?????? ????????? ????????? ??????. --%>
                <sec:authentication property="principal" var="pinfo"/>
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${pinfo.username eq board.writer}">
                        <button data-oper="modify" class="btn btn-default"
                                onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">MODIFY
                        </button>
                    </c:if>
                </sec:authorize>


                <button data-oper="list" class="btn btn-info"
                        onclick="location.href='/board/list'">LIST
                </button>

                <form id="operForm" action="/board/modify" method="get">
                    <sec:csrfInput/>
                    <input type="hidden" id="bno" name="bno" value="<c:out value="${board.bno}"/>"/>
                    <%-- ????????? Criteria ??? ?????? ?????? ????????????, ??? ???????????? ????????????. --%>
                    <input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum}"/>"/>
                    <input type="hidden" name="amount" value="<c:out value="${cri.amount}"/>"/>
                    <%-- ??????????????? ???????????? ????????? ??? ????????? -> ??????????????? -> ??????????????? ???????????? ????????? ??? ?????????  --%>
                    <input type="hidden" name="keyword" value="<c:out value="${cri.keyword}"/>"/>
                    <input type="hidden" name="type" value="<c:out value="${cri.type}"/>"/>
                </form>

            </div>
            <%-- .panel-body --%>
        </div>
        <%-- .panel-body --%>
    </div>
    <%-- .panel --%>
</div>
<%-- /.row --%>

<div class="bigPictureWrapper">
    <div class="bigPicture"></div>
</div>

<%-- File area start --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <div class="panel-body">
                <div class="uploadResult">
                    <ul></ul>
                </div>
                <%-- uploadResult --%>
            </div>
            <%-- panel-body --%>
        </div>
        <%--panel--%>
    </div>
    <%-- col --%>
</div><%-- Files row end  --%>

<%-- reply area start --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <%-- ????????? ??? ???????????? ???????????? ???????????? ??????. --%>
                <sec:authorize access="isAuthenticated()">
                    <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
                </sec:authorize>
            </div>
            <div class="panel-body">
                <%--  start ul  --%>
                <ul class="chat">
                    <%-- reply start --%>
                    <li class="left clearfix" data-rno="21">
                        <div>
                            <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2022-08-23 22:22</small>
                            </div>
                            <p>TEST REPLY</p>
                        </div>
                    </li>
                    <%-- reply end --%>
                </ul>
                <%--  end ul --%>
            </div>
            <%-- .panel chat-panel --%>
            <div class="panel-footer">

            </div>
            <%-- .panel-footer --%>
        </div>
        <%-- row end --%>
    </div>
    <%-- reply area end --%>

    <%-- Modal --%>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
         aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <input type="hidden" name="X-CSRF-TOKEN" value="${_csrf.token}" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Reply</label>
                        <input class="form-control" name="reply" value="NEW REPLY"/>
                    </div>
                    <div class="form-group">
                        <label>Replier</label>
                        <input class="form-control" name="replier" value="REPLIER" readonly/>
                    </div>
                    <div class="form-group">
                        <label>Reply Date</label>
                        <input class="form-control" name="replyDate" value=""/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="modalModBtn" class="btn btn-warning">Modify</button>
                    <button type="button" id="modalRemoveBtn" class="btn btn-danger">Remove</button>
                    <button type="submit" id="modalRegisterBtn" class="btn btn-default">Register</button>
                    <button type="button" id="modalClassBtn" class="btn btn-info" data-dismiss="modal">Close</button>
                </div>
            </div>
            <%-- /.modal content end --%>
        </div>
        <%-- /.modal dialog end --%>
    </div>
    <%-- /.Modal end --%>

    <%-- ????????? jsp ????????? ?????? script ????????? ?????? src ??? ?????? script ??? ?????? ????????? ???,
     ???????????? ?????? script ?????? ???????????? ???????????? ????????????. ?????? ????????? ???????????? ?????? 20220824 --%>
    <script type="text/javascript" src="/resources/js/reply.js"></script>
    <script>
        $(document).ready(function () {

            let bnoValue = '<c:out value="${board.bno}"/>';
            let replyUL = $(".chat");

            showList(1);

            function showList(page) {

                replyService.getList({bno: bnoValue, page: page || 1},
                    function (replyCnt, list) {

                        console.log("reply Cnt : " + replyCnt);
                        console.log("list : " + list);

                        // ????????? ????????? -1 ??? ????????? ????????? ???????????? ????????? ????????????.
                        if (page == -1) {
                            let pageNum = Math.ceil(replyCnt / 10.0);
                            showList(pageNum);
                            return;
                        }

                        let str = "";
                        if (list == null || list.length == 0) {
                            // replyUL.html("");

                            return;
                        }
                        for (let i = 0, len = list.length || 0; i < len; i++) {
                            str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
                            str += "<div><div class='header'><strong class='primary-font'>[" + list[i].rno + "] " + list[i].replier + "</strong>";
                            str += "<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
                            str += "<p>" + list[i].reply + "</p></div></li>";
                        }
                        replyUL.html(str);
                        showReplyPage(replyCnt);
                    }); // function end
            } // showList end

            // modal ?????? ?????? button ??????. ?????? ??? ???????????? ????????? ????????? ??? ????????????..
            let modal = $(".modal");
            let modalInputReply = modal.find("input[name='reply']");
            let modalInputReplier = modal.find("input[name='replier']");
            let modalInputReplyDate = modal.find("input[name='replyDate']");

            let modalModBtn = $("#modalModBtn");
            let modalRemoveBtn = $("#modalRemoveBtn");
            let modalRegisterBtn = $("#modalRegisterBtn");

            let replier = null;

            <sec:authorize access="isAuthenticated()">
                replier = '<sec:authentication property="principal.username"/>';
            </sec:authorize>

            let csrfHeaderName = "X-CSRF-TOKEN";
            let csrfTokenValue = "${_csrf.token}";


            // ???????????? ????????? ?????????????????? ?????? script.
            $("#addReplyBtn").on("click", function (e) {

                modal.find("input").val("");
                // ????????? ??? ??????, replier ????????? ????????? username ??? ?????????.
                modal.find("input[name='replier']").val(replier);
                modalInputReplyDate.closest("div").hide();
                modal.find("button[id != 'modalCloseBtn']").hide();

                modalRegisterBtn.show();

                $(".modal").modal("show");

            });

            // ?????? ????????? ?????? ??????
            $(".chat").on("click", "li", function () {

                let rno = $(this).data("rno");
                replyService.get(rno, function (reply) {
                    // input ????????? ?????? ???????????? ??????????????? ??????.
                    modalInputReply.val(reply.reply);
                    modalInputReplier.val(reply.replier);
                    // ??????????????? ????????? ???????????? readonly ??????.
                    modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
                    modal.data("rno", reply.rno);

                    // modalCloseBtn ??? hide & Modify / Remove ????????? show
                    modal.find("button[id != 'modalCloseBtn']").hide();
                    modalModBtn.show();
                    modalRemoveBtn.show();

                    $(".modal").modal("show");
                })
            });

            // CSRF ????????? ??????. ????????? ??????????????? ????????????($(document)), ajax ???????????? beforeSend ?????? ????????? ????????? ?????????.
            $(document).ajaxSend(function (e, xhr, option) {
                xhr.setRequestHeader("X-CSRF-TOKEN",csrfTokenValue);
                console.log("ajaxSend csrfTokenValue : " + csrfTokenValue);
            });

            modalRegisterBtn.on("click", function (e) {

                let reply = {
                    reply: modalInputReply.val(),
                    replier: modalInputReplier.val(),
                    bno: bnoValue
                };

                replyService.add(reply, function (result) {
                    // ????????? ??? ??? ??????/?????? ????????? ?????? & ????????? ?????? input ?????? ????????? modal ??? ??????.
                    alert(result);

                    modal.find("input").val("");
                    modal.modal("hide");

                    // ?????? ?????? ??? ????????? ?????? ????????????
                    // ** -1 ??? param ?????? ?????? ??????????
                    // -> ??? ????????? ????????? ??? ?????? ?????? ????????? ????????? ???????????? ????????? ???????????? ???????????? ??????????????? ??????.

                    showList(-1);

                });

            });

            // ?????? ?????? event
            modalModBtn.on("click", function (e) {

                let originalReplier = modalInputReplier.val();

                let reply = {
                    rno: modal.data("rno"),
                    reply: modalInputReply.val(),
                    replier : originalReplier
                };

                if (!replier) {
                    alert("????????? ????????? ?????????.");
                    modal.modal("hide");
                    return;
                }

                console.log("originalReplier : " + originalReplier)

                if (replier != originalReplier) {
                    alert("??? ????????? ????????? ????????? ????????????.");
                    modal.modal("hide");
                    return;
                }

                // ?????? ??? modal ??? ?????? ?????? ????????????.
                replyService.update(reply, function (result) {
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                });

            });

            modalRemoveBtn.on("click", function (e) {

                let rno = modal.data("rno");

                // ????????? ??? ???????????? ????????????
                if (!replier) {
                    alert("?????? ????????? ???????????????.");
                    modal.modal("hide");
                    return;
                }

                // ????????? ???????????? ???????????? ??????.
                let originalReplier = modalInputReplier.val();
                if (replier != originalReplier) {
                    alert("??? ????????? ????????? ????????? ????????????.");
                    modal.modal("hide");
                    return;
                }

                replyService.remove(rno, originalReplier, function (result) {
                    // ?????? ??? modal ??? ?????? ?????? ????????????.
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                });

            });

            let pageNum = 1; // ????????? ??????
            let replyPageFooter = $(".panel-footer");

            function showReplyPage(replyCnt) {

                let endNum = Math.ceil(pageNum / 10.0) * 10;
                let startNum = endNum - 9;
                let prev = startNum != 1;
                let next = false;

                if (endNum * 10 >= replyCnt) {
                    endNum = Math.ceil(replyCnt / 10.0);
                }

                if (endNum * 10 < replyCnt) {
                    next = true;
                }

                let str = "<ul class='pagination pull-right'>";

                if (prev) {
                    str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>Prev</a></li>";
                }

                for (let i = startNum; i <= endNum; i++) {

                    let active = pageNum == i ? "active" : "";

                    str += "<li class='page-item " + active + "'><a class='page-link' href='" + i + "'>" + i + "</a></li>";

                }

                if (next) {
                    str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
                }

                str += "</ul></div>";

                replyPageFooter.html(str);

            }

            replyPageFooter.on("click", "li a", function (e) {

                e.preventDefault();
                console.log("page clicked");

                let targetPageNum = $(this).attr("href");
                console.log("page number: " + targetPageNum);

                pageNum = targetPageNum;

                showList(pageNum);
            })
        });
    </script>

    <script>
        // bno ???
        <%--let bnoValue = '<c:out value="${board.bno}"/>';--%>

        // replyService.add() ????????????.
        <%-- replyService.add(
                {reply: "TEST REPL", replier: "TEST REPLIER", bno: bnoValue},
                function (result) {
                     alert("RESULT : " + result);
                }
            );
         --%>

        // ?????? ???????????? get ???????????? ????????? ?????? ?????? ????????? console ??? ????????????.
        // replyService.getList({bno: bnoValue, page: 1}, function (list) {
        //
        //     for (let i = 0, len = list.length || 0; i < len; i++) {
        //         console.log(list[i]);
        //     }
        //
        // })

        // ??? ?????? param ??? ?????? rno ??? ?????? ????????? ????????????.
        <%-- replyService.remove(9, function (cnt) {
            console.log(cnt);

            if (cnt == "success") {
                alert("?????????????????????");
            }
        }, function (err) {
            alert("ERROR........");
        }); --%>

        /* replyService.update({rno: 4, bno: bnoValue, reply: "============MODIFIED============"},
             function (result) {
                 alert("????????????" + result);
             })

         replyService.get(4, function (data) {
             console.log(data);
         });
 */
    </script>

    <script type="text/javascript">
        $(document).ready(function () {

            let operForm = $("#operForm");

            $("button[data-oper='modify']").on("click", function (e) {

                operForm.attr("action", "/board/modify").submit();

            });

            $("button[data-oper='list']").on("click", function () {

                operForm.find("#bno").remove();
                operForm.attr("action", "/board/list");
                operForm.submit();

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
                            "data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                            "<div><img src='/display?fileName=" + fileCallPath + "'>" +
                            "</div></li>";

                    } else {

                        str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' " +
                            "data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>" +
                            "<div><span>" + attach.fileName + "</span><br/>" +
                            "<img src='/resources/img/attach.png'/>" +
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
        })

    </script>
<%@ include file="../includes/footer.jsp" %>