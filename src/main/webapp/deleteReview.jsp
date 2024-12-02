<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="review.ReviewDAO" %>
<%@ page import="User.UserDTO" %>
<%@ page import="User.UserDAO" %>
<%
    // 로그인한 사용자 정보 가져오기
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    long sessionUserId;
    try {
        sessionUserId = Long.parseLong(userDAO.findUserId(loggedInUser.getLoginId()));
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('사용자 정보를 가져오는 데 오류가 발생했습니다.'); window.location.href='naverMap.jsp';</script>");
        return;
    }

    ReviewDAO reviewDAO = new ReviewDAO();
    long reviewUserId = Long.valueOf(request.getParameter("reviewUserId"));
    long userId = Long.valueOf(request.getParameter("userId"));

    try {
        // 사용자 ID가 세션 사용자 ID와 일치하는지 확인
        if (userId == sessionUserId) {
            boolean isDeleted = reviewDAO.delete(reviewUserId, userId);
            if (isDeleted) {
                // 삭제 성공 시 alert 후 naverMap.jsp로 리다이렉트
                out.println("<script>alert('리뷰가 삭제되었습니다.'); window.location.href='naverMap.jsp';</script>");
            } else {
                out.println("<script>alert('리뷰 삭제에 실패했습니다.'); window.location.href='naverMap.jsp';</script>");
            }
        } else {
        	System.out.println("유저아이디: " + userId);
        	System.out.println("세션유저아이디: " + sessionUserId);
            out.println("<script>alert('권한이 없습니다.'); window.location.href='naverMap.jsp';</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다.'); window.location.href='naverMap.jsp';</script>");
    }
%>
