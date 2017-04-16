<%--
  Created by IntelliJ IDEA.
  User: zhao
  Date: 2017/4/10
  Time: 15:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="login-div" style="padding: 20px; margin: 20px; width: 30%; border: solid 2px #eee" hidden>
    <form >
        <div id="alert-no-exist" class="alert alert-danger" role="alert" hidden>用户名不存在或密码错误！</div>
        <div id="alert-name-error" class="alert alert-danger" role="alert" hidden>登录失败！用户名由a-zA-Z0-9_组成，长度3－12位！</div>
        <div id="alert-pass-result" class="alert alert-success" role="alert" hidden></div>

        <div class="form-group">
            <label for="login-name">用户名</label>
            <input type="text" class="form-control" id="login-name" placeholder="用户名">
        </div>

        <div class="form-group">
            <label for="login-pass">密码</label>
            <input onkeydown="login_passKeyAction()" type="password" class="form-control" id="login-pass" placeholder="密码">
        </div>

        <input id="btn-login" class="btn btn-primary" value="登录" />
        <a onclick="toggle(1)">再试一次</a>
    </form>
</div>

<script type="text/javascript">
    var login_pass_record = "key,ms,type\n";
    var login_pass_ab_pre = -1;
    var login_pass_re_pre = -1;

    var login_pass_filter = function (ms) {
        var ans = ms - login_pass_ab_pre + login_pass_re_pre;
        if(ms <= login_pass_ab_pre) {
            ans += 60000;
        }
        if(login_pass_ab_pre == -1 && login_pass_re_pre == -1) {
            ans = 0;
        }
        login_pass_ab_pre = ms;
        login_pass_re_pre = ans;
        return ans;
    }

    var login_passKeyAction = function(a) {
        var e = event || window.event || arguments.callee.caller.arguments[0];
        var d = new Date();
        var str = e.keyCode +","+ login_pass_filter(d.getSeconds()*1000 + d.getMilliseconds())+','+a+"\n";
        login_pass_record += str;
    }
    $(document).ready(function () {
        $("#btn-login").click(function () {
            var name = $("#login-name").val();
            var pass = $("#login-pass").val();
            if(name.length<3 || name.length>12 || !name.match("[a-zA-Z0-9_]+")){
                var flag1=0;
                $("#alert-name-error").show();
            }
            else {
                $("#alert-name-error").hide();
                $.post('login',
                    {
                        user_name: name,
                        user_pass: pass,
                        pass_record: login_pass_record,
                    },
                    function (res) {
                        if (res == "") {
                            $("#alert-pass-result").hide();
                            $("#alert-no-exist").show();
                        } else {
                            $("#alert-no-exist").hide();
                            $("#alert-pass-result").html("登录成功！匹配率" + res + "%");
                            $("#alert-pass-result").show();
                        }
                    })
            }
        })
    })
</script>