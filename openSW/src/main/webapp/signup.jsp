<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" href="css/signup.css"/>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>

<%-- 네비게이션 바 --%>
<jsp:include page="/component/navbar.jsp" />

<%-- 회원가입 폼 --%>
<div class="signup-container">
    <div class="signup-form">
        <h2 class="form-heading">회원가입</h2>
        <form action="processAddMember.jsp" method="post">
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
                <button type="submit" class="btn btn-primary">회원가입</button>
            </div>
        </form>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
    // 성조야 id 중복기능 추가할거면 여기다가 해라 
</script>

</body>
</html>
