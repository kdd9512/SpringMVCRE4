<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../includes/header.jsp" %>

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
            <div class="panel-heading">
                BoardList Page
                <button id="regBtn" type="button" class="btn btn-xs pull-right">REGISTER NEW BOARD</button>
            </div>

            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="panel-body">
                    <table class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>#번호</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>수정일</th>
                        </tr>
                        </thead>
                        <c:forEach items="${list}" var="board">
                            <tr>
                                <td><c:out value="${board.bno}"/></td>
                                <td>
                                    <a class="move" href="<c:out value="${board.bno}"/>">
                                    <c:out value="${board.title}"/>   <b>[  <c:out value="${board.replyCnt}"/>  ]</b>
                                    </a>
                                </td>
                                <td><c:out value="${board.writer}"/></td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd"
                                                    value="${board.regDate}"/></td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd"
                                                    value="${board.updateDate}"/></td>
                            </tr>
                        </c:forEach>
                    </table>

                    <div class="row">
                        <div class="col-lg-12">

                            <form id="searchForm" action="/board/list" method="get">
                                <select name="type">
                                    <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/> >------</option>
                                    <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/> >제목</option>
                                    <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/> >내용</option>
                                    <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/> >작성자</option>
                                    <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/> >제목 + 내용</option>
                                    <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/> >제목 + 작성자</option>
                                    <option value="TCW" <c:out value="${pageMaker.cri.type eq 'TCW' ? 'selected' : ''}"/> >제목 + 내용 + 작성자</option>
                                </select>
                                <input type="text" name="keyword" value="<c:out value="${pageMaker.cri.keyword}"/>"/>
                                <input type="hidden" name="pageNum" value="<c:out value="${pageMaker.cri.pageNum}"/>"/>
                                <input type="hidden" name="amount" value="<c:out value="${pageMaker.cri.amount}"/>">
                                <button class="btn btn-default">Search</button>
                            </form>

                        </div>
                    </div>

                    <%-- pagination --%>
                    <div class="pull-right">
                        <ul class="pagination">

                            <c:if test="${pageMaker.prev}">
                                <li class="paginate_button previous">
                                    <a href="${pageMaker.startPage - 1}">Previous</a>
                                </li>
                            </c:if>

                            <c:forEach var="num"
                                       begin="${pageMaker.startPage}"
                                       end="${pageMaker.endPage}">
                                <li class="paginate_button ${pageMaker.cri.pageNum == num ? "active" : ""}">
                                    <a href="${num}">${num}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${pageMaker.next}">
                                <li class="paginate_button next">
                                    <a href="${pageMaker.endPage + 1}">Next</a>
                                </li>
                            </c:if>

                        </ul>
                    </div>
                    <%-- pagination end --%>

                    <%-- 페이지 이동에 필요한 param 전달용 hidden --%>
                    <form id="actionForm" action="/board/list" method="get">
                        <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                        <input type="hidden" name="type" value="<c:out value="${pageMaker.cri.type}"/>">
                        <input type="hidden" name="keyword" value="<c:out value="${pageMaker.cri.keyword}"/>">
                    </form>

                    <%-- modal --%>
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                         aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"
                                            aria-hidden="true">&times;
                                    </button>
                                    <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                </div>
                                <div class="modal-body">
                                    처리가 완료되었습니다.
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default"
                                            data-dismiss="modal">Close
                                    </button>
                                    <button type="button" class="btn btn-primary">Save changes</button>
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
                </div>
                <!-- /.panel-body -->
            </div>
            <!-- /.panel -->
        </div>
    </div>
    <!-- /.row -->
</div>
<script type="text/javascript">
    <%-- 도배방지용 모달창에서 사용할 script --%>
    $(document).ready(function () {

        let result = '<c:out value="${result}"/>';

        checkModal(result);

        history.replaceState({},null,null); // 뒤로가기를 했을 때 다시 생성결과를 알리는 모달창이 뜨는 것을 방지한다.

        function checkModal(result) {

            if (result === '' || history.state) {
                return;
            }

            if (parseInt(result) > 0) {
                $(".modal-body").html("게시글" + parseInt(result) + " 번이 등록되었습니다.");
            }

            $("#myModal").modal("show");
        }

        $("#regBtn").on("click", function () {
            self.location = "/board/register";
        });

        let actionForm = $("#actionForm");

        // paginate_button 클래스의 a태그
        $(".paginate_button a").on("click", function (e) {

            e.preventDefault();

            console.log("click");

            actionForm.find("input[name='pageNum']").val($(this).attr("href"));
            actionForm.submit();

        });

        $(".move").on("click", function (e) {

            e.preventDefault();

            // bno 가 중복으로 생성되어 링크가 제대로 동작하지 않는 경우를 방지. 추후 삭제 예정.
            let bno = actionForm.find("input[name='bno']").val();
            if(bno!=''){
                actionForm.find("input[name='bno']").remove();
            }

            // 이하의 input 태그를 추가로 전송한다. .attr() 로 요소의 값을 추출하고. .append() 로 선택요소의 마지막에 추가한다.
            // this(=a태그)의 href 에 적힌 주소에는 value 로 bno 가 담겨있으므로 href 값을 가져오면 해결.
            actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href") +"'>")
            // 위에서 가져온 bno 값을 기준으로 /board/get 을 요청한다.
            actionForm.attr("action", "/board/get");
            // 위 2개 를 submit
            actionForm.submit();

        })

        // 검색기능 script
        let searchForm = $("#searchForm");

        $("#searchForm button").on("click", function (e) {

            if(!searchForm.find("option:selected").val()) {
                alert("검색유형을 선택해야 합니다.")
                return false;
            }

            if(!searchForm.find("input[name='keyword']").val()) {
                alert("검색어가 없습니다.");
                return false;
            }

            searchForm.find("input[name='pageNum']").val("1");
            e.preventDefault();

            searchForm.submit();

        });

    });
</script>
<%@ include file="../includes/footer.jsp" %>
