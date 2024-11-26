<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>홈</title>
    <link rel="stylesheet" href="./component/css/navbar.css">
</head>
<div class="navbar">
    <ul>
   		<li class="logo"><img src="./img/chan.jpeg"></li>
        <li><a href="home.jsp">홈</a></li>
        <li><a href="shop">쇼핑</a></li>
        <li><a href="sell.jsp">판매하기</a></li>
        
        <!-- 로그인되지 않은 경우 로그인, 회원가입 링크 표시 -->
        <c:if test="${empty sessionScope.username}">
            <li><a href="login.jsp">로그인</a></li>
            <li><a href="signup.jsp">회원가입</a></li>
        </c:if>

        <!-- 로그인된 상태에서만 사용자 이름 표시, 오른쪽 끝에 배치 -->
        <c:if test="${not empty sessionScope.username}">
            <li class="user-info"><a href="userInfo.jsp">${sessionScope.username} 님</a></li>
            <li><a href="logout.jsp">로그아웃</a></li>
        </c:if>
    </ul>
</div>


