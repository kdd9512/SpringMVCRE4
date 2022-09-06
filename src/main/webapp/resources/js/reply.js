console.log("Reply Module Test-------------------------------");

let replyService = (function () {

    function add(reply, callback, error) {
        console.log("add reply--------------------------------------");

        $.ajax({
            type: "POST",
            url: "/replies/new",
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function (result, status, xhr) {
                if (callback) {
                    callback(result);
                }
            },
            error: function (xhr, status, err) {
                if (error) {
                    error(err);
                }
            }
        })
    }

    function getList(param, callback, error) {

        let bno = param.bno;
        let page = param.page || 1;

        $.getJSON("/replies/pages/" + bno + "/" + page + ".json",
            function (data) {
                if (callback) {
                    // callback(data); -- 댓글 목록만을 가져온다.
                    callback(data.replyCnt, data.list); // 댓글 숫자와 목록을 가져온다
                }
            }
        ).fail(function (xhr, status, err) {
            if (error) {
                error();
            }
        });
    }

    function remove(rno, callback, error) {
        $.ajax({
            type: "DELETE",
            url: "/replies/" + rno,
            success: function (deleteResult, status, xhr) {
                if (callback) {
                    callback(deleteResult);
                }
            },
            error: function (xhr, status, err) {
                if (error) {
                    error(err);
                }
            }
        });
    }

    function update(reply,callback, error) {

        console.log("RNO : " + reply.rno);

        // 20220827 modalModBtn update 이하 작동 안하던 문제.
        // 원인 : success 의 callback 을 return 하지 않아서...
        // (저게 있어야 success / fail 을 전송한다)
        $.ajax({
            type: "PUT",
            url: "/replies/" + reply.rno,
            data: JSON.stringify(reply),
            contentType: "application/json; charset=utf-8",
            success: function (updateResult, status, xhr) {
                if (callback) {
                    callback(updateResult);
                    console.log("RESULT? : " + updateResult);
                }
            },
            error: function (xhr, status, err) {
                if (error) {
                    error(err);
                }
            }
        });

    }

    function get(rno, callback, error) {

        $.get("/replies/" + rno + ".json", function(result) {

            if (callback) {
                callback(result);
            }
        }).fail(function(xhr, status, err) {
            if (error) {
                error(err);
            }
        })

    }

    function displayTime(timeValue) {

        let today = new Date();
        let gap = today.getTime() - timeValue;

        let dateObj = new Date(timeValue);
        let str = "";

        if (gap < (1000 * 60 * 60 * 24)) {

            let hh = dateObj.getHours();
            let mi = dateObj.getMinutes();
            let ss = dateObj.getSeconds();

            return [ (hh > 9 ? '' : '0') + hh, ':',
                (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
        } else {

            let yy = dateObj.getFullYear();
            let mm = dateObj.getMonth() + 1; // getMonth() 는 0 부터 시작.
            let dd = dateObj.getDate();

            return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/',
                (dd > 9 ? '' : '0') + dd ].join('');

        }

    }

    return {
        add: add,
        getList: getList,
        remove: remove,
        update: update,
        get: get,
        displayTime: displayTime
    };
})();