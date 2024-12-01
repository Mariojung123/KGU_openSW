<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>식당 추천</title>
</head>
<body>
    <h1>추천된 식당 목록</h1>

    <%
        restaurant.RestaurantDAO dao = new restaurant.RestaurantDAO();

        List<restaurant.Restaurant> suwonRestaurants = dao.getRestaurantsByRegion("수원시"); 
        List<restaurant.Restaurant> anyangRestaurants = dao.getRestaurantsByRegion("안양시"); 
        List<restaurant.Restaurant> hansikRestaurants = dao.getRestaurantsByCategory("한식"); 
        List<restaurant.Restaurant> ilsikRestaurants = dao.getRestaurantsByCategory("일식"); 
        List<restaurant.Restaurant> jungsikRestaurants = dao.getRestaurantsByCategory("중식");
        List<restaurant.Restaurant> yangsikRestaurants = dao.getRestaurantsByCategory("양식"); 

        request.setAttribute("suwonRestaurants", suwonRestaurants);
        request.setAttribute("anyangRestaurants", anyangRestaurants);
        request.setAttribute("hansikRestaurants", hansikRestaurants);
        request.setAttribute("ilsikRestaurants", ilsikRestaurants);
        request.setAttribute("jungsikRestaurants", jungsikRestaurants);
        request.setAttribute("yangsikRestaurants", yangsikRestaurants);
    %>

    <h2>경기대 학생들을 위한 수원시 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${suwonRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>
    
    <h2>수원 근처 맛집이 많은 안양시 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${anyangRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>

    <h2>한식을 좋아하는 사람들을 위한 한식 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${hansikRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>

    <h2>회와 초밥을 좋아하는 일식 러버들을 위한 일식 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${ilsikRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>

    <h2>중식이 생각날 때? 중식 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${jungsikRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>

    <h2>분위기 좋게 스테이크 썰고 싶을 때 양식 맛집</h2>
    <ul>
        <c:forEach var="restaurant" items="${yangsikRestaurants}">
            <li>
                <strong>${restaurant.name}</strong><br>
                주소: ${restaurant.address}<br>
                전화번호: ${restaurant.phone}<br>
                카테고리: ${restaurant.category}<br>
            </li>
        </c:forEach>
    </ul>

</body>
</html>
