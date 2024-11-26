<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>네이버 지도 - 지역별 음식점 표시 슈웃</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=es3iw874ms&submodules=clustering"></script>
    <style>
        #map {
            width: 100%;
            height: 800px;
        }

        button {
            margin: 10px;
            padding: 10px;
        }
    </style>
</head>
<body>
<h1>네이버 지도 - 지역별 음식점 표시 슈웃</h1>
<button onclick="moveToRegion('경기도', 37.4128, 127.5183)">경기도</button>
<button onclick="moveToRegion('충청도', 36.5184, 127.8802)">충청도</button>
<button onclick="moveToRegion('전라도', 35.8173, 127.1500)">전라도</button>
<button onclick="moveToRegion('경상도', 35.4606, 128.6600)">경상도</button>
<button onclick="moveToRegion('강원도', 37.8228, 128.1555)">강원도</button>

<div id="map"></div>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<String[]> restaurantData = new ArrayList<>();

    try {
        String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
        String dbID = "root";
        String dbPassword = "1234";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String SQL = "SELECT SIGUN_NM, RESTRT_NM, REPRSNT_FOOD_NM, REFINE_WGS84_LAT, REFINE_WGS84_LOGT FROM restaurant_info";
        pstmt = conn.prepareStatement(SQL);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String[] data = {
                rs.getString("SIGUN_NM"),
                rs.getString("RESTRT_NM"),
                rs.getString("REPRSNT_FOOD_NM"),
                rs.getString("REFINE_WGS84_LAT"),
                rs.getString("REFINE_WGS84_LOGT")
            };
            restaurantData.add(data);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<script>
    var map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(36.5, 127.5),
        zoom: 7
    });

    var restaurants = [
        <% for (String[] data : restaurantData) { %>
        {
            sigun: '<%= data[0] %>',
            name: '<%= data[1] %>',
            food: '<%= data[2] %>',
            lat: <%= data[3] %>,
            lng: <%= data[4] %>
        },
        <% } %>
    ];

    var markers = [];
    restaurants.forEach(function (restaurant) {
        var marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(restaurant.lat, restaurant.lng),
            map: map,
            title: restaurant.name,
            icon: {
                content: '<div style="color: red; font-size: 20px; font-weight: bold;">❤️</div>',
                anchor: new naver.maps.Point(10, 10)
            }
        });

        naver.maps.Event.addListener(marker, 'click', function () {
            map.setCenter(new naver.maps.LatLng(restaurant.lat, restaurant.lng));
            map.setZoom(15); // 확대
        });

        markers.push(marker);
    });

    function moveToRegion(region, lat, lng) {
        map.setCenter(new naver.maps.LatLng(lat, lng));
        map.setZoom(12); 

        markers.forEach(function (marker) {
            var title = marker.getTitle(); 
            if (title.includes(region)) {
                marker.setIcon({
                    content: '<div style="color: blue; font-size: 20px; font-weight: bold;">💙</div>' 
                });
            } else {
                marker.setIcon({
                    content: '<div style="color: red; font-size: 20px; font-weight: bold;">❤️</div>'
                });
            }
        });
    }
</script>
</body>
</html>
