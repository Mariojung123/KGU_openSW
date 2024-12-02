<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="User.UserDTO" %>
<jsp:useBean id="userDAO" class="User.UserDAO" scope="page" />
<jsp:useBean id="user" class="User.UserDTO" scope="session" />

<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");

    UserDTO foundUser = userDAO.findByLoginId(loginId);
    if (foundUser != null && foundUser.getPassword().equals(password)) {
        session.setAttribute("loggedInUser", foundUser);
%>
    <script>
        alert("로그인에 성공했습니다.");
        window.location.href = "home.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("아이디 또는 비밀번호가 잘못되었습니다.");
        history.back();
    </script>
<%
    }
%>
