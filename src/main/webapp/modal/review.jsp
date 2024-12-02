<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, jakarta.servlet.*, jakarta.servlet.http.*, java.sql.*" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="review.Review" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 목록</title>
    <link rel="stylesheet" href="css/modal.css"> <!-- CSS 파일 링크 -->
</head>
<body>

<%
    // restaurantId 가져오기
    String restaurantIdStr = request.getParameter("restaurantId");
    Long restaurantId = Long.parseLong(restaurantIdStr);

    // ReviewDAO 객체 생성하여 리뷰 가져오기
    ReviewDAO reviewDAO = new ReviewDAO();
    List<Review> reviews = reviewDAO.findAllByRestaurantId(restaurantId);
%>

<div class="review-container">
<%
    if (reviews.isEmpty()) {
%>
        <p class="no-reviews">리뷰가 없습니다.</p>
<%
    } else {
        for (Review review : reviews) {
%>
            <div class="review">
                <h4 class="review-title"><%= review.getTitle() %></h4>
                <p class="review-user"><strong><%= review.getUserId() %></strong> (Rating: <%= review.getRating() %>)</p> <!-- 여기 DAO좀 건드려서 유저 이름 가지고 오게 해야해 -->
                <p class="review-content"><%= review.getContent() %></p>
                <p class="review-date"><small>작성일: <%= review.getCreatedDate() %></small></p>
            </div>
<%
        }
    }
%>
</div>

</body>
</html>
