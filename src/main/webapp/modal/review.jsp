<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, jakarta.servlet.*, jakarta.servlet.http.*, java.sql.*" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="review.Review" %>
<%@ page import="User.User"%>
<%@ page import="User.UserDTO" %>
<%@ page import="User.UserDAO" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 목록</title>
    <link rel="stylesheet" href="css/modal.css"> <!-- CSS 파일 링크 -->
    <script src="js/modal.js"></script> <!-- JS 파일 링크 -->
</head>
<body>

<%
    // restaurantId 가져오기
    String restaurantIdStr = request.getParameter("restaurantId");
    Long restaurantId = Long.parseLong(restaurantIdStr);
    
    // 세션에서 사용자 이름 가져오기
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
    UserDAO userDAO = new UserDAO();
    String userId = null;

    // 로그인한 사용자 ID 가져오기
    if (loggedInUser != null) {
        userId = String.valueOf(userDAO.findUserId(loggedInUser.getLoginId()));
    }
    
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
        	long reviewUserId = review.getUserId();
        	User reviewer = userDAO.findOne(reviewUserId);
%>			
            <div class="review">
                <h4 class="review-title"><%=  reviewer.getName() %></h4>
                <p class="review-user"><strong><%= reviewer.getLoginId() %></strong> (Rating: <%= review.getRating() %>)</p>
                <p class="review-content"><%= review.getContent() %></p>
                <p class="review-date"><small>작성일: <%= review.getCreatedDate() %></small></p>
                <%
                    // 리뷰 작성자와 세션 사용자 비교
                    
                    if (userId != null && userId.equals(String.valueOf(review.getUserId()))) {
                    	System.out.println("userId: " + userId);
                    	System.out.println("sessionUserId: " + String.valueOf(review.getUserId()));
                %>
                    <form action="deleteReview.jsp" method="POST" style="display:inline;">
                        <input type="hidden" name="reviewUserId" value="<%= review.getReviewId() %>">
                        <input type="hidden" name="userId" value="<%= userId %>">
                        <button type="submit" onclick="return confirm('리뷰를 삭제하시겠습니까?');">삭제</button>
                    </form>
                <%
                    }
                %>
            </div>
<%
        }
    }
%>
</div>

<% if (loggedInUser != null) { %>
    <!-- 리뷰 작성 버튼 -->
    <button onclick="toggleReviewForm()">리뷰 작성</button>

    <!-- 리뷰 작성 폼 -->
    <div id="reviewForm" style="display: none; margin-top: 20px;">
        <h3>리뷰 작성</h3>
        <form action="submitReview.jsp" method="POST">
            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
            <div>
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required>
            </div>
            <div>
                <label for="content">내용:</label>
                <textarea id="content" name="content" rows="4" required></textarea>
            </div>
            <div>
                <label for="rating">평점:</label>
                <select id="rating" name="rating" required>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
            </div>
            <div>
                <button type="submit">리뷰 제출</button>
            </div>
        </form>
    </div>
<% } else { %>
    <p>리뷰를 작성하려면 로그인해주세요.</p>
<% } %>

</body>
</html>
