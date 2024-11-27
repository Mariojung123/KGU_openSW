package User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
		}
		return "";
	}
	
	public int getNext() {
		String SQL = "SELECT userId FROM user ORDER BY userId DESC";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return -1; // 데이터베이스 오류
	}
	
	public User findOne(Long userId) {
		String SQL = "SELECT * FROM user WHERE userId = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				User user = new User();
				user.setUserId(rs.getLong("userId"));
				user.setLoginId(rs.getString("loginId"));
				user.setPassword(rs.getString("password"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setCreatedDate(rs.getString("createdDate"));
				return user;
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
	
	public List<User> findAll() {
		List<User> users = new ArrayList<>();
		String SQL = "SELECT * FROM user";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				User user = new User();
				user.setUserId(rs.getLong("userId"));
				user.setLoginId(rs.getString("loginId"));
				user.setPassword(rs.getString("password"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setCreatedDate(rs.getString("createdDate"));
				users.add(user);
			}
			return users;
		} catch (Exception e) {
			e.printStackTrace();
	    } finally {
	        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    }
		return users;
	}
	
	public int createUser(UserDTO dto) {
		String SQL = "INSERT INTO user (userId, loginId, password, name, email, createdDate) VALUES (?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setLong(1, getNext());
			pstmt.setString(2, dto.getLoginId());
			pstmt.setString(3, dto.getPassword());
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getEmail());
			pstmt.setString(6, getDate());
			return pstmt.executeUpdate();
		} catch (Exception e) {
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
