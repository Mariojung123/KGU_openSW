package review;

import java.sql.*;
import java.util.List;

import User.User;

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
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT reviewId FROM review ORDER BY reviewId DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public Review findOne(Long reviewId) {
		String SQL = "SELECT r FROM review r WHERE r.reviewId = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, reviewId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return (Review) rs.getObject(1);
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@SuppressWarnings("null")
	public List<Review> findAll() {
		List<Review> reviews = null;
		String SQL = "SELECT r FROM review r";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				reviews.add((Review) rs.getObject(1));
			}
			return reviews;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return reviews;
	}
	
	public int write(User user, ReviewDTO dto) {
		String SQL = "INSERT INTO review (reviewId, title, user, createdDate, content, rating) VALUE(?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, getNext());
			pstmt.setString(2, dto.getTitle());
			pstmt.setObject(3, user);
			pstmt.setString(4, getDate());
			pstmt.setString(5, dto.getContent());
			pstmt.setDouble(6, dto.getRating());
			rs = pstmt.executeQuery();
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int modify(User user, ReviewDTO dto) {
		String SQL = "UPDATE r FROM review r SET r.title = ?, r.content = ?, r.rating = ? WHERE r.user = ? AND r.reviewId = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setDouble(3, dto.getRating());
			rs = pstmt.executeQuery();
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int delete(Long reviewId, User user) {
		String SQL = "DELETE FROM review r WHERE r.reviewId = ? AND r.user = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, reviewId);
			pstmt.setObject(2, user);
			rs = pstmt.executeQuery();
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
}
