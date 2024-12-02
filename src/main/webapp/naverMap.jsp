<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.net.*, org.json.*, restaurant.RestaurantDAO, restaurant.Restaurant" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>경기도 맛집 지도</title>
	    <link rel="stylesheet" href="css/common.css">
		<link rel="stylesheet" href="css/naverMap.css">
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=es3iw874ms"></script>
</head>
<body>
    <nav>
<jsp:include page="navbar.jsp" />
    </nav>
    
    <div class="content">
        <div id="map-container">
            <div class="controls">
                <input type="text" id="citySearch" class="search-box" placeholder="도시 검색 (예: 수원시)">
                <button onclick="searchCity()">검색</button>
            </div>
            <div id="map"></div>
        </div>
        
        <div class="restaurant-list-container">
            <h2>주변 음식점</h2>
            <div id="restaurantList"></div>
        </div>
    </div>

    <div id="restaurantModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">×</span>
            <h2 id="modalName"></h2>
            <img id="modalImage" src="" alt="음식점 이미지" />
            <p id="modalDescription"></p>
        </div>
    </div>

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
    RestaurantDAO restaurantDAO = new RestaurantDAO();
    if (jsonData != null) {
        try {
            JSONObject jsonObj = new JSONObject(jsonData);
            if (jsonObj.has("PlaceThatDoATasteyFoodSt") &&
                jsonObj.getJSONArray("PlaceThatDoATasteyFoodSt").length() > 1 &&
                jsonObj.getJSONArray("PlaceThatDoATasteyFoodSt").getJSONObject(1).has("row")) {
                
                JSONArray rows = jsonObj.getJSONArray("PlaceThatDoATasteyFoodSt")
                                       .getJSONObject(1)
                                       .getJSONArray("row");
                for (int i = 0; i < rows.length(); i++) {
                    JSONObject item = rows.getJSONObject(i);
                    
                    Restaurant restaurant = new Restaurant(
                        item.getString("SIGUN_NM"),
                        item.getString("RESTRT_NM"),
                        item.optString("REFINE_ROADNM_ADDR", ""),
                        item.optString("TASTFDPLC_TELNO", ""),
                        item.optDouble("REFINE_WGS84_LAT", 0.0),
                        item.optDouble("REFINE_WGS84_LOGT", 0.0)
                    );
                    restaurantDAO.insertRestaurant(restaurant);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
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
        markers.forEach(function(marker) {
            marker.setMap(null);
        });
        markers = [];

        var bounds = new naver.maps.LatLngBounds();
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
    function updateRestaurantList(restaurants) {
        var restaurantList = document.getElementById('restaurantList');
        restaurantList.innerHTML = '';

        restaurants.forEach(function(restaurant) {
            var card = document.createElement('div');
            card.className = 'restaurant-card';
            card.innerHTML = '<h3><a href="#" onclick="showRestaurantInfo(' + JSON.stringify(restaurant) + ')">' + restaurant.name + '</a></h3>';
            restaurantList.appendChild(card);
        });
    }

    function showRestaurantInfo(restaurant) {
        var modal = document.getElementById('restaurantModal');
        var modalName = document.getElementById('modalName');
        var modalDescription = document.getElementById('modalDescription');
        var modalImage = document.getElementById('modalImage');

        modalName.textContent = restaurant.name;
        modalDescription.textContent = '지역: ' + restaurant.sigun + '\n대표 메뉴: ' + restaurant.food + '\n주소: ' + restaurant.addr + '\n전화: ' + restaurant.tel;
        modalImage.src = restaurant.image || '';

        modal.style.display = 'block';
    }

    function closeModal() {
        var modal = document.getElementById('restaurantModal');
        modal.style.display = 'none';
    }
    document.getElementById('citySearch').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchCity();
        }
    });

    if(restaurants.length > 0) {
        createMarkers(restaurants);
        updateRestaurantList(restaurants);
    }
</script>

</body>
</html>