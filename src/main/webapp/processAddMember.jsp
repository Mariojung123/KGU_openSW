<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="user" class="User.UserDTO" scope="request" />
<jsp:useBean id="userDAO" class="User.UserDAO" scope="page" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 처리</title>
</head>
<body>

<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    if (userDAO.findByLoginId(loginId) == null) {
        user.setLoginId(loginId);
        user.setPassword(password);
        user.setName(name);
        user.setEmail(email);

        int result = userDAO.createUser(user);

        if (result == 1) {
%>
            <script>
                alert("회원가입이 성공적으로 완료되었습니다.");
                window.location.href = "login.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("회원가입 중 오류가 발생했습니다. 다시 시도해 주세요.");
                history.back();
            </script>
<%
        }
    } else {
%>
        <script>
            alert("이미 존재하는 아이디입니다.");
            history.back();
        </script>
<%
    }
%>

</body>
</html>
