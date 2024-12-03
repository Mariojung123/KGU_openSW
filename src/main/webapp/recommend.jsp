<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛집 추천</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/recommend.css">
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=es3iw874ms"></script>
</head>
<body>
    <nav>
        <jsp:include page="navbar.jsp" />
    </nav>
    <div class="content">
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

          <div class="restaurant-section">
            <div class="section-title">
                <h2>경기대 학생들을 위한 수원시 맛집</h2>
                <span class="restaurant-count">${suwonRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${suwonRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

               <div class="restaurant-section">
            <div class="section-title">
                <h2>안양 맛집</h2>
                <span class="restaurant-count">${anyangRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${anyangRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
          <div class="restaurant-section">
            <div class="section-title">
                <h2>한식 맛집</h2>
                <span class="restaurant-count">${hansikRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${hansikRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
          <div class="restaurant-section">
            <div class="section-title">
                <h2>일식 맛집</h2>
                <span class="restaurant-count">${ilsikRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${ilsikRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
          <div class="restaurant-section">
            <div class="section-title">
                <h2>중식 맛집</h2>
                <span class="restaurant-count">${jungsikRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${jungsikRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
          <div class="restaurant-section">
            <div class="section-title">
                <h2>양식 맛집</h2>
                <span class="restaurant-count">${yangsikRestaurants.size()}개의 맛집</span>
            </div>
            <div class="restaurant-list-container">
                <div class="restaurant-slider">
                    <ul class="restaurant-list">
                        <c:forEach var="restaurant" items="${yangsikRestaurants}">
                            <li class="restaurant-card">
                                <img src="${pageContext.request.contextPath}/img/${restaurant.name}.jpg" 
                                     alt="${restaurant.name}" 
                                     class="restaurant-image"
                                     onerror="this.src='${pageContext.request.contextPath}/img/default.jpg'">
                                <p class="restaurant-name">${restaurant.name}</p>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        
    </div>
</body>
</html>