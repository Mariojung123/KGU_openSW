<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    session.invalidate(); // 현재 세션을 무효화하여 로그아웃 처리

    // 로그아웃 완료 메시지와 함께 리다이렉트
    response.setContentType("text/html; charset=UTF-8"); // 응답의 문자 인코딩 설정
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그아웃</title>
    <script type="text/javascript">
        alert('로그아웃되었습니다.'); // 로그아웃 알림
        window.location.href = 'home.jsp'; // 홈 페이지로 리다이렉트
    </script>
</head>
<body>
</body>
</html>
