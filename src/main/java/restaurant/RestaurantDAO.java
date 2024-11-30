package restaurant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {
    private Connection conn;

    public RestaurantDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/KGU_openSW";
            String dbID = "root";
            String dbPassword = "12";
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

    public void insertRestaurant(Restaurant restaurant) {
        String SQL = "INSERT INTO restaurant_info (region, name, address, phone, la, lo) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, restaurant.getRegion());
            pstmt.setString(2, restaurant.getName());
            pstmt.setString(3, restaurant.getAddress());
            pstmt.setString(4, restaurant.getPhone());
            pstmt.setDouble(5, restaurant.getLatitude());
            pstmt.setDouble(6, restaurant.getLongitude());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
