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

                <%-- 글을 작성한 사람만 수정 버튼이 보이게 수정. --%>
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
                    <input type="hidden" id="bno" name="bno" value="<c:out value="${board.bno}"/>"/>
                    <%-- 전송된 Criteria 의 값을 받아 보관하고, 타 페이지로 전송한다. --%>
                    <input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum}"/>"/>
                    <input type="hidden" name="amount" value="<c:out value="${cri.amount}"/>"/>
                    <%-- 검색기준이 적용되어 결과를 낸 리스트 -> 조회페이지 -> 검색기준이 적용되어 결과를 낸 리스트  --%>
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
                <%-- 로그인 한 사용자만 댓글작성 가능하게 수정. --%>
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
                        <input class="form-control" name="replier" value="REPLIER"/>
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

    <%-- 반드시 jsp 내에서 굴릴 script 이전에 이하 src 가 있는 script 를 먼저 작성한 후,
     이하에서 새로 script 탭을 작성하여 진행해야 작동한다. 이게 없으면 작동하질 않음 20220824 --%>
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

                        // 페이지 번호가 -1 인 경우에 마지막 페이지를 찾아다 호출한다.
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

            // modal 내의 모든 button 목록. 일단 다 불러와야 기능을 부여할 수 있으므로..
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

            let csrfHeaderName = "${_csrf.parameterName}";
            let csrfTokenValue = "${_csrf.token}";

            // 필요없는 버튼을 숨김처리하기 위한 script.
            $("#addReplyBtn").on("click", function (e) {

                modal.find("input").val("");
                // 로그인 한 경우, replier 변수에 기록된 username 을 받아옴.
                modal.find("input[name='replier']").val(replier);
                modalInputReplyDate.closest("div").hide();
                modal.find("button[id != 'modalCloseBtn']").hide();

                modalRegisterBtn.show();

                $(".modal").modal("show");

            });

            // CSRF 토큰을 전송. 여기에 기본값으로 설정하면($(document)), ajax 쓸때마다 beforeSend 써서 호출할 필요가 없어짐.
            $(document).ajaxSend(function (e, xhr, option) {
                xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
            })

            modalRegisterBtn.on("click", function () {

                let reply = {
                    reply: modalInputReply.val(),
                    replier: modalInputReplier.val(),
                    bno: bnoValue
                };

                replyService.add(reply, function (result) {
                    // 댓글을 쓴 후 성공/실패 여부를 알림 & 성공한 경우 input 창을 비우고 modal 을 닫음.
                    alert(result);

                    modal.find("input").val("");
                    modal.modal("hide");

                    // 댓글 등록 후 목록을 다시 불러온다
                    // ** -1 을 param 으로 넣는 이유는?
                    // -> 새 댓글을 추가할 시 먼저 전체 댓글의 숫자를 파악하고 마지막 페이지를 호출하여 이동시키기 위함.

                    showList(-1);

                });

            });

            // 기존 댓글을 수정한다.
            $(".chat").on("click", "li", function () {

                let rno = $(this).data("rno");
                replyService.get(rno, function (reply) {
                    // input 태그의 값을 가져와서 초기값으로 입력.
                    modalInputReply.val(reply.reply);
                    modalInputReplier.val(reply.replier);
                    // 작성날짜는 바꾸면 안되므로 readonly 처리.
                    modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
                    modal.data("rno", reply.rno);

                    // modalCloseBtn 을 hide & Modify / Remove 버튼을 show
                    modal.find("button[id != 'modalCloseBtn']").hide();
                    modalModBtn.show();
                    modalRemoveBtn.show();

                    $(".modal").modal("show");
                })
            });

            // 수정 버튼 event
            modalModBtn.on("click", function (e) {

                let reply = {
                    rno: modal.data("rno"),
                    reply: modalInputReply.val()
                };

                // 수정 후 modal 을 닫고 목록 새로고침.
                replyService.update(reply, function (result) {
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                });

            });

            modalRemoveBtn.on("click", function (e) {

                let rno = modal.data("rno");

                // 로그인 후 삭제기능 이용가능
                if (!replier) {
                    alert("먼저 로그인 해야합니다.");
                    modal.modal("hide");
                    return;
                }

                // 작성자 이외에는 수정권한 없음.
                let originalReplier = modalInputReplier.val();
                if (replier != originalReplier) {
                    alert("이 댓글을 수정할 권한이 없습니다.");
                    modal.modal("hide");
                    return;
                }

                replyService.remove(rno, function (result) {
                    // 수정 후 modal 을 닫고 목록 새로고침.
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                });

            });

            let pageNum = 1; // 페이지 개수
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

                console.log("str : " + str);

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
        // bno 값
        <%--let bnoValue = '<c:out value="${board.bno}"/>';--%>

        // replyService.add() 테스트용.
        <%-- replyService.add(
                {reply: "TEST REPL", replier: "TEST REPLIER", bno: bnoValue},
                function (result) {
                     alert("RESULT : " + result);
                }
            );
         --%>

        // 현재 열람중인 get 페이지가 가지고 있는 댓글 목록을 console 에 출력한다.
        // replyService.getList({bno: bnoValue, page: 1}, function (list) {
        //
        //     for (let i = 0, len = list.length || 0; i < len; i++) {
        //         console.log(list[i]);
        //     }
        //
        // })

        // 첫 번째 param 과 같은 rno 를 가진 댓글을 삭제한다.
        <%-- replyService.remove(9, function (cnt) {
            console.log(cnt);

            if (cnt == "success") {
                alert("삭제되었습니다");
            }
        }, function (err) {
            alert("ERROR........");
        }); --%>

        /* replyService.update({rno: 4, bno: bnoValue, reply: "============MODIFIED============"},
             function (result) {
                 alert("수정완료" + result);
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