package review;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    private String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
    private String dbID = "root";
    private String dbPassword = "1234";

    public ReviewDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 현재 날짜 구하기
     * @return String
     */
    public String getDate() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
    
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbURL, dbID, dbPassword);
    }
    
    /**
     * 리뷰ID로 리뷰 객체 찾기
     * @param reviewId (Long)
     * @return Review
     */
    public Review findOne(Long reviewId) {
        String SQL = "SELECT * FROM review WHERE reviewId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapToReview(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * DB 내에 있는 모든 리뷰 찾기
     * @return List<Review>
     */
    public List<Review> findAll() {
        List<Review> reviews = new ArrayList<>();
        String SQL = "SELECT * FROM review";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    /**
     * 해당 유저가 작성한 모든 리뷰 찾기
     * @param userId (Long)
     * @return List<Review>
     */
    public List<Review> findAllByUserId(Long userId) {
        List<Review> reviews = new ArrayList<>();
        String SQL = "SELECT * FROM review WHERE userId = ?";
        try (Connection conn = getConnection();
            PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapToReview(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    /**
     * 해당 식당에 등록된 모든 리뷰 찾기
     * @param restaurantId (Long)
     * @return List<Review>
     */
    public List<Review> findAllByRestaurantId(Long restaurantId) {
        List<Review> reviews = new ArrayList<>();
        String SQL = "SELECT * FROM review WHERE restaurantId = ?";

        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {  
            pstmt.setLong(1, restaurantId);  
            try (ResultSet rs = pstmt.executeQuery()) {  
                while (rs.next()) {
                    Review review = mapToReview(rs);  // ResultSet에서 데이터를 객체로 변환
                    reviews.add(review);  // 리스트에 추가
                    System.out.println("Title: " + review.getTitle());  // 제목 출력
                }
            }
        } catch (SQLException e) {
            System.out.println("SQLException 발생: " + e.getMessage());  
            e.printStackTrace();
        }

        return reviews;
    }

    
    
    /**
     * 리뷰 작성하기
     * @param userId (Long)
     * @param restaurantId (Long)
     * @param dto (ReviewDTO)
     * @return int
     */
    public int write(Long userId, Long restaurantId, ReviewDTO dto) {
        String insertSQL = "INSERT INTO review (title, userId, restaurantId, createdDate, content, rating) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
            pstmt.setString(1, dto.getTitle());
            pstmt.setLong(2, userId);
            pstmt.setLong(3, restaurantId);
            pstmt.setString(4, getDate());
            pstmt.setString(5, dto.getContent());
            pstmt.setDouble(6, dto.getRating());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * 리뷰 수정하기
     * @param userId (Long)
     * @param dto (ReviewDTO)
     * @return int
     */
    public int modify(Long userId, ReviewDTO dto) {
        String SQL = "UPDATE review SET title = ?, content = ?, rating = ? WHERE userId = ? AND reviewId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setDouble(3, dto.getRating());
            pstmt.setLong(4, userId);
            pstmt.setLong(5, dto.getReviewId());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * 리뷰 삭제하기 
     * @param reviewId (Long)
     * @param userId (Long)
     * @return int -> boolean
     */
    public boolean delete(Long reviewId, Long userId) {
        String SQL = "DELETE FROM review WHERE reviewId = ? AND userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, reviewId);
            pstmt.setLong(2, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0; // 삭제된 행 수가 0보다 크면 true 반환
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // 예외 발생 시 false 반환
        }
    }

    
    /**
     * 특정 리뷰 평점 구하기
     * @param restaurantId (Long)
     * @return double
     */
    public double getAverageRating(Long restaurantId) {
        String SQL = "SELECT AVG(rating) FROM review WHERE restaurantId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, restaurantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    /**
     * 해당 식당에 달린 리뷰 개수 찾기
     * @param restaurantId (Long)
     * @return int
     */
    public int getReviewCountByRestaurant(Long restaurantId) {
        String SQL = "SELECT COUNT(*) FROM review WHERE restaurantId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, restaurantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * 해당 리뷰가 해당 유저의 것인지 검증
     * @param reviewId (Long)
     * @param userId (Long)
     * @return boolean
     */
    public boolean isReviewOwnedByUser(Long reviewId, Long userId) {
        String SQL = "SELECT COUNT(*) FROM review WHERE reviewId = ? AND userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, reviewId);
            pstmt.setLong(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    /**
     * ResultSet으로부터 Review 객체로 변경하기 
     * @param rs (ResultSet)
     * @return Review
     * @throws SQLException
     */
    private Review mapToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getLong("reviewId"));
        review.setUserId(rs.getLong("userId"));
        review.setRestaurantId(rs.getLong("restaurantId"));
        review.setTitle(rs.getString("title"));
        review.setContent(rs.getString("content"));
        review.setRating(rs.getDouble("rating"));
        review.setCreatedDate(rs.getString("createdDate"));
        return review;
    }
}