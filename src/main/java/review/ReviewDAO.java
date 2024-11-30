package review;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    private String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
    private String dbID = "root";
    private String dbPassword = "12";

    public ReviewDAO() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public String getDate() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dbURL, dbID, dbPassword);
    }

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

    public List<Review> findAllByRestaurantId(Long restaurantId) {
        List<Review> reviews = new ArrayList<>();
        String SQL = "SELECT * FROM review WHERE restaurantId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, restaurantId);
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

    // 리뷰 수정
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

    public int delete(Long reviewId, Long userId) {
        String SQL = "DELETE FROM review WHERE reviewId = ? AND userId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setLong(1, reviewId);
            pstmt.setLong(2, userId);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

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
