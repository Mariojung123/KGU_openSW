package review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public ReviewDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
			String dbID = "root";
			String dbPassword = "12";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT reviewId FROM review ORDER BY reviewId DESC";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인경우
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return -1; // 데이터베이스 오류
	}
	
	public Review findOne(Long reviewId) {
		String SQL = "SELECT * FROM review WHERE reviewId = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, reviewId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Review review = new Review();
				review.setReviewId(rs.getLong("reviewId"));
				review.setUserId(rs.getLong("userId"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setRating(rs.getDouble("rating"));
				review.setCreatedDate(rs.getString("createdDate"));
				return review;
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return null;
	}
	
	public List<Review> findAll() {
		List<Review> reviews = new ArrayList<>();
		String SQL = "SELECT * FROM review";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Review review = new Review();
				review.setReviewId(rs.getLong("reviewId"));
				review.setUserId(rs.getLong("userId"));
				review.setTitle(rs.getString("title"));
				review.setContent(rs.getString("content"));
				review.setRating(rs.getDouble("rating"));
				review.setCreatedDate(rs.getString("createdDate"));
				reviews.add(review);
			}
			return reviews;
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return reviews;
	}
	
	public int write(Long userId, ReviewDTO dto) {
		String SQL = "INSERT INTO review (reviewId, title, userId, createdDate, content, rating) VALUES (?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, getNext());
			pstmt.setString(2, dto.getTitle());
			pstmt.setObject(3, userId);
			pstmt.setString(4, getDate());
			pstmt.setString(5, dto.getContent());
			pstmt.setDouble(6, dto.getRating());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return -1;
	}
	
	public int modify(Long userId, ReviewDTO dto) {
		String SQL = "UPDATE review SET title = ?, content = ?, rating = ? WHERE userId = ? AND reviewId = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setDouble(3, dto.getRating());
			pstmt.setLong(4, userId);
			pstmt.setLong(5, dto.getReviewId());
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
	    } finally {
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return -1;
	}
	
	public int delete(Long reviewId, Long userId) {
		String SQL = "DELETE FROM review WHERE reviewId = ? AND userId = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, reviewId);
			pstmt.setObject(2, userId);
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
	    } finally {
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return -1;
	}
	
	public void close() {
	    try {
	        if (conn != null) conn.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
}
