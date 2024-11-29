package restaurant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestauarantDAO {
    private Connection conn;

    public RestauarantDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
            String dbID = "root";
            String dbPassword = "1234";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Restaurant> getRestaurantsByRegion(String region) {
        List<Restaurant> list = new ArrayList<>();
        String SQL = "SELECT * FROM restaurant_info WHERE region = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, region);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(new Restaurant(
                    rs.getString("region"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("phone"),
                    rs.getDouble("la"),
                    rs.getDouble("lo")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
