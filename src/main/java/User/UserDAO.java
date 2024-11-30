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
			String dbPassword = "1234";
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
	
	public UserDTO findByLoginId(String loginId) {
	    String SQL = "SELECT * FROM user WHERE loginId = ?";
	    try {
	        pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, loginId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            UserDTO userDTO = new UserDTO();
	            userDTO.setLoginId(rs.getString("loginId"));
	            userDTO.setPassword(rs.getString("password"));
	            userDTO.setName(rs.getString("name"));
	            userDTO.setEmail(rs.getString("email"));
	            return userDTO;
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
	    String insertSQL = "INSERT INTO user (loginId, password, name, email, createdDate) VALUES (?, ?, ?, ?, ?)";
	    String selectSQL = "SELECT NOW()"; // 날짜를 가져오는 쿼리
	    
	    try {
	        // 날짜 먼저 가져오기
	        pstmt = conn.prepareStatement(selectSQL);
	        ResultSet rs = pstmt.executeQuery();
	        
	        String currentDate = null;
	        if (rs.next()) {
	            currentDate = rs.getString(1);
	        }
	        
	        pstmt.close();
	        pstmt = conn.prepareStatement(insertSQL);
	        pstmt = conn.prepareStatement(insertSQL);
	        pstmt.setString(1, dto.getLoginId());
	        pstmt.setString(2, dto.getPassword());
	        pstmt.setString(3, dto.getName());
	        pstmt.setString(4, dto.getEmail());
	        pstmt.setString(5, currentDate);
	        int result = pstmt.executeUpdate();

	        return result;
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
