</div>
<!-- Bootstrap Core JavaScript -->
<script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

<!-- DataTables JavaScript -->
<script src="/resources/vendor/datatables/js/jquery.dataTables.min.js"></script>
<script src="/resources/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
<script src="/resources/vendor/datatables-responsive/dataTables.responsive.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/resources/dist/js/sb-admin-2.js"></script>

<!-- Page-Level Demo Scripts - Tables - Use for reference -->
<script>
    $(document).ready(function () {
        $('#dataTables-example').DataTable({
            responsive: true
        });
        // header / footer 분리 후 jquery script 를 header 로 이동시 발생하는 문제 ->
        // 모바일 크기에서 새로고침 시 메뉴 아코디언이 멋대로 펼처지는 현상 방지.
        $(".sidebar-nav")
            .attr("class", "sidebar-nav navbar-collapse collapse")
            .attr("aria-expanded", "false")
            .attr("style", "height:1px")
    });

</script>

</body>

</html>
