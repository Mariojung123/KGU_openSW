<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
<link rel="stylesheet" href="css/common.css">
<link rel="stylesheet" href="css/signup.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>

<%-- 네비게이션 바 --%>
<jsp:include page="navbar.jsp" />

<%-- 회원가입 폼 --%>
<div class="signup-container">
    <div class="signup-form">
        <h2 class="form-heading">회원가입</h2>
        <form action="processAddMember.jsp" method="post" id="signupForm">
            <!-- Login ID -->
            <div class="form-group">
                <label for="loginId">아이디</label>
                <input type="text" name="loginId" id="loginId" class="form-control" placeholder="아이디" required>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" name="password" class="form-control" placeholder="비밀번호" required>
            </div>

            <!-- Name -->
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" name="name" class="form-control" placeholder="이름" required>
            </div>

            <!-- Email -->
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" name="email" class="form-control" placeholder="이메일" required>
            </div>

            <!-- Submit Button -->
            <div class="form-group">
                <!-- '등록' 버튼 클릭 시 자바스크립트로 로그인 페이지로 이동 -->
                <button type="submit" class="btn btn-primary" onclick="redirectToLogin(event)">등록</button>
            </div>
        </form>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
    // '등록' 버튼 클릭 시 login.jsp로 이동하는 함수
    function redirectToLogin(event) {
        event.preventDefault(); // 폼 전송을 막음
        // 폼을 먼저 제출한 후, login.jsp로 이동
        document.getElementById("signupForm").submit(); // 폼 제출
        //window.location.href = "login.jsp"; // 로그인 페이지로 이동
    }
</script>

</body>
</html>
