<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
</div>
<%--/.row--%>

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

                <button data-oper="modify" class="btn btn-default"
                        onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">MODIFY
                </button>
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

<%-- reply area start --%>
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
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
            <div class="panel-footer"></div>
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

                replyService.getList({bno: bnoValue, page: page || 1}, function (replyCnt, list) {

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
                        replyUL.html("");

                        return;
                    }
                    for (let i = 0, len = list.length || 0; i < len; i++) {
                        str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
                        str += "<div><div class='header'><strong class='primary-font'>" + list[i].replier + "</strong>";
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

            // 필요없는 버튼을 숨김처리하기 위한 script.
            $("#addReplyBtn").on("click", function (e) {

                modal.find("input").val("");
                modalInputReplyDate.closest("div").hide();
                modal.find("button[id != 'modalCloseBtn']").hide();

                modalRegisterBtn.show();

                $(".modal").modal("show");

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

                if(next) {
                    str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
                }

                str += "</ul></div>";

                console.log("str : " + str);

                replyPageFooter.html(str);

            }

            replyPageFooter.on("click", function (e) {
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
        let bnoValue = '<c:out value="${board.bno}"/>';

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
<%@ include file="../includes/footer.jsp" %>