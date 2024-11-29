<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.net.*, org.json.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>경기도 맛집 지도</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=es3iw874ms"></script>
    <style>
        #map { width: 100%; height: 800px; }
        .controls {
            margin: 10px;
            padding: 10px;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-box {
            padding: 8px;
            margin-right: 10px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 8px 15px;
            margin: 5px;
            border: none;
            border-radius: 4px;
            background-color: #0077ff;
            color: white;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="controls">
    <input type="text" id="citySearch" class="search-box" placeholder="도시 검색 (예: 수원시)">
    <button onclick="searchCity()">검색</button>
</div>
<div id="map"></div>

<%!
    public String getRestaurantData(String sigunNm) {
        try {
            String baseUrl = "https://openapi.gg.go.kr/PlaceThatDoATasteyFoodSt";
            String apiKey = "6f58f277adc64ca9944e2b5275530ebb"; // 실제 API 키로 변경 필요
            
            StringBuilder urlBuilder = new StringBuilder(baseUrl);
            urlBuilder.append("?Key=").append(URLEncoder.encode(apiKey, "UTF-8"));
            urlBuilder.append("&Type=json");
            urlBuilder.append("&pIndex=1");
            urlBuilder.append("&pSize=1000");
            
            if(sigunNm != null && !sigunNm.trim().isEmpty()) {
                urlBuilder.append("&SIGUN_NM=").append(URLEncoder.encode(sigunNm, "UTF-8"));
            }
            
            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            BufferedReader rd;
            if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }
            
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            conn.disconnect();
            
            return sb.toString();
            
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }
    }
%>

<%
    String cityParam = request.getParameter("city");
    String jsonData = getRestaurantData(cityParam);
%>

<script>
    var map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(37.4138, 127.5183), // 경기도 중심
        zoom: 11
    });

    var restaurants = [];
    var markers = [];

    <% if(jsonData != null) { %>
        try {
            var jsonObj = <%= jsonData %>;
            if(jsonObj.PlaceThatDoATasteyFoodSt && 
               jsonObj.PlaceThatDoATasteyFoodSt[1] && 
               jsonObj.PlaceThatDoATasteyFoodSt[1].row) {
                
                restaurants = jsonObj.PlaceThatDoATasteyFoodSt[1].row.map(function(item) {
                    return {
                        name: item.RESTRT_NM,
                        sigun: item.SIGUN_NM,
                        food: item.REPRSNT_FOOD_NM,
                        lat: parseFloat(item.REFINE_WGS84_LAT),
                        lng: parseFloat(item.REFINE_WGS84_LOGT),
                        addr: item.REFINE_ROADNM_ADDR,
                        tel: item.TASTFDPLC_TELNO
                    };
                });
            }
        } catch(e) {
            console.error("데이터 파싱 에러:", e);
        }
    <% } %>

    function createMarkers(filteredRestaurants) {
        // 기존 마커 제거
        markers.forEach(function(marker) {
            marker.setMap(null);
        });
        markers = [];

        var bounds = new naver.maps.LatLngBounds();
        
        // 새로운 마커 생성
        filteredRestaurants.forEach(function(restaurant) {
            if(restaurant.lat && restaurant.lng) {
                var position = new naver.maps.LatLng(restaurant.lat, restaurant.lng);
                
                var marker = new naver.maps.Marker({
                    position: position,
                    map: map,
                    icon: {
                        content: '<div style="color: red; font-size: 20px;">❤️</div>',
                        anchor: new naver.maps.Point(10, 10)
                    }
                });

                var infoWindow = new naver.maps.InfoWindow({
                    content: '<div style="padding:10px;min-width:200px;line-height:150%;">' +
                            '<h4>' + restaurant.name + '</h4>' +
                            '<p>지역: ' + restaurant.sigun + '</p>' +
                            '<p>대표 메뉴: ' + restaurant.food + '</p>' +
                            '<p>주소: ' + restaurant.addr + '</p>' +
                            '<p>전화: ' + restaurant.tel + '</p>' +
                            '</div>'
                });

                naver.maps.Event.addListener(marker, 'click', function() {
                    if (infoWindow.getMap()) {
                        infoWindow.close();
                    } else {
                        infoWindow.open(map, marker);
                    }
                });

                bounds.extend(position);
                markers.push(marker);
            }
        });

        if(markers.length > 0) {
            map.fitBounds(bounds);
        }
    }

    function searchCity() {
        var searchTerm = document.getElementById('citySearch').value.trim();
        var filteredRestaurants = restaurants.filter(function(restaurant) {
            return restaurant.sigun.includes(searchTerm);
        });
        
        if(filteredRestaurants.length > 0) {
            createMarkers(filteredRestaurants);
        } else {
            alert('검색된 맛집이 없습니다.');
        }
    }

    document.getElementById('citySearch').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchCity();
        }
    });

    // 초기 마커 생성
    if(restaurants.length > 0) {
        createMarkers(restaurants);
    }
</script>

</body>
</html>