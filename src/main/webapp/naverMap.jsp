<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, restaurant.RestaurantDAO, restaurant.Restaurant, org.json.*" %>
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

    <!-- 모달 구조 -->
	<div id="myModal" class="modal">
	    <div class="modal-content">
	        <span class="close" id="closeModal">&times;</span>
	        <h3 id="modalTitle"></h3>
	        <div id="modalRegion"></div> <!-- 리뷰가 삽입될 부분 -->
	    </div>
	</div>




<%
    RestaurantDAO restaurantDAO = new RestaurantDAO();
    List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();

    JSONArray restaurantJsonArray = new JSONArray();
    for (Restaurant restaurant : restaurants) {
        JSONObject restaurantJson = new JSONObject();
        restaurantJson.put("restaurantId", restaurant.getRestaurantId());
        restaurantJson.put("name", restaurant.getName());
        restaurantJson.put("sigun", restaurant.getRegion());
        restaurantJson.put("addr", restaurant.getAddress());
        restaurantJson.put("tel", restaurant.getPhone());
        restaurantJson.put("lat", restaurant.getLatitude());
        restaurantJson.put("lng", restaurant.getLongitude());
        restaurantJson.put("food", ""); // DB에 대표 메뉴가 없을 경우 빈 값 처리
        restaurantJsonArray.put(restaurantJson);
    }
%>

<script>
    var map = new naver.maps.Map('map', {
        center: new naver.maps.LatLng(37.4138, 127.5183), // 경기도 중심
        zoom: 11
    });

    var restaurants = <%= restaurantJsonArray.toString() %>;
    var markers = [];

    function createMarkers(filteredRestaurants) {
        markers.forEach(function(marker) {
            marker.setMap(null);
        });
        markers = [];

        var bounds = new naver.maps.LatLngBounds();
        filteredRestaurants.forEach(function(restaurant) {
            if (restaurant.lat && restaurant.lng) {
                var position = new naver.maps.LatLng(restaurant.lat, restaurant.lng);
                var marker = new naver.maps.Marker({
                    position: position,
                    map: map,
                    icon: {
                        content: '<div style="color: red; font-size: 20px;">❤️</div>',
                        anchor: new naver.maps.Point(10, 10)
                    }
                });

                naver.maps.Event.addListener(marker, 'click', function() {
                    openModal(restaurant.restaurantId);
                });

                bounds.extend(position);
                markers.push(marker);
            }
        });

        if (markers.length > 0) {
            map.fitBounds(bounds);
        }
    }

    function searchCity() {
        var searchTerm = document.getElementById('citySearch').value.trim();


        var filteredRestaurants = restaurants.filter(function(restaurant) {
            return restaurant.sigun.includes(searchTerm) || restaurant.name.includes(searchTerm);
        });

        if (filteredRestaurants.length > 0) {
            createMarkers(filteredRestaurants); // 검색 결과로 마커 업데이트
            updateRestaurantList(filteredRestaurants); // 검색 결과로 리스트 업데이트
        } else {
            alert('검색된 맛집이 없습니다.');
        }
    }


    function updateRestaurantList(restaurants) {
        var restaurantList = document.getElementById('restaurantList');
        restaurantList.innerHTML = '';

        restaurants.forEach(function(restaurant, index) {
            var card = document.createElement('div');
            card.className = 'restaurant-card';
            card.setAttribute('data-lat', restaurant.lat);
            card.setAttribute('data-lng', restaurant.lng);
            card.setAttribute('data-index', index); // 마커 배열과 매칭
            card.innerHTML = '<h3>' + restaurant.name + '</h3>' +
				            '<p>지역: ' + restaurant.sigun + '</p>' +
				            '<p>주소: ' + restaurant.addr + '</p>' +
				            '<p>전화: ' + restaurant.tel + '</p>' +
				            '<div style="text-align: right;">' +  // 오른쪽 정렬을 위한 div 추가
				            '<button id="place-button" style="margin-right: 10px;">위치 보기</button>' +
				            '<button id="review-button">리뷰 보기</button>' +
				            '</div>';  // div 닫기



			//버튼 클릭 리스너 등록
			const placebutton = card.querySelector('#place-button');
			if (placebutton) {
				placebutton.addEventListener('click', function() {
			    	moveToRestaurant(index);
			    });
			}
            
           
            const reviewbutton = card.querySelector('#review-button');
			if (reviewbutton) {
				reviewbutton.addEventListener('click', function() {
	                openModal(restaurant.restaurantId);
	            });
			}

            restaurantList.appendChild(card);
        });
    }

    function openModal(restaurantId) {
        fetch('modal/review.jsp?restaurantId=' + restaurantId)
            .then(response => response.text())  // HTML로 변환
            .then(data => {
                // 모달 제목 설정
                document.getElementById('modalTitle').innerHTML = '리뷰 목록';
                document.getElementById('modalRegion').innerHTML = data; // HTML 데이터 삽입

                // 모달 보여주기
                document.getElementById('myModal').style.display = "block";
            })
            .catch(error => console.error('Error fetching data:', error));
    }


    function moveToRestaurant(index) {
        if (markers[index]) {
            var marker = markers[index];
            var position = marker.getPosition();

            
            map.setCenter(position);
            map.setZoom(15);

        
            /* naver.maps.Event.trigger(marker, 'click'); */
        }
    }

    if (restaurants.length > 0) {
        createMarkers(restaurants);
        updateRestaurantList(restaurants);
    }

</script>
<script type="text/javascript" src="js/modal.js"></script>

</body>
</html>
