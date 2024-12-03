<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="review.ReviewDTO" %>
<%@ page import="User.UserDTO" %>
<%@ page import="User.UserDAO" %>
<%
    // 세션에서 사용자 정보를 가져옵니다.
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
    UserDAO userDAO = new UserDAO();
    long userId;

    if (loggedInUser == null) {
        // 사용자가 로그인하지 않았을 때 알림을 띄우고 naverMap.jsp로 리다이렉트
        out.println("<script type=\"text/javascript\">");
        out.println("alert('사용자가 로그인하지 않았습니다.');");
        out.println("window.location.href='naverMap.jsp';");
        out.println("</script>");
        return; // 메서드 종료
    }

    userId = Long.parseLong(userDAO.findUserId(loggedInUser.getLoginId()));
    System.out.println("사용자 userId: " + userId);
    Long restaurantId = Long.parseLong(request.getParameter("restaurantId"));

    String title = request.getParameter("title");
    String content = request.getParameter("content");
    double rating = Double.parseDouble(request.getParameter("rating"));

    // ReviewDTO 객체 생성
    ReviewDTO reviewDto = new ReviewDTO();
    reviewDto.setTitle(title);
    reviewDto.setContent(content);
    reviewDto.setRating(rating);

    // ReviewDAO 객체 생성
    ReviewDAO reviewDao = new ReviewDAO();
    int result = reviewDao.write(userId, restaurantId, reviewDto);

    if (result > 0) {
        out.println("<script>");
        out.println("alert('리뷰 작성이 완료되었습니다.');"); // 리뷰 작성 완료 알림
        out.println("window.location.href='naverMap.jsp';"); // naverMap.jsp로 리다이렉트
        out.println("</script>");
    } else {
        out.println("<script>alert('리뷰 작성에 실패했습니다.'); history.back();</script>");
    }
%>
