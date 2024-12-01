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
            String dbPassword = "1234";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String SQL = "SELECT * FROM restaurant";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(new Restaurant(
                    rs.getString("region"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("phone"),
                    rs.getDouble("la"),
                    rs.getDouble("lo"),
                    rs.getString("category")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Restaurant> getRestaurantsByRegion(String region) {
        List<Restaurant> list = new ArrayList<>();
        String SQL = "SELECT * FROM restaurant WHERE region = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, region);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Restaurant(
                        rs.getString("region"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getDouble("la"),
                        rs.getDouble("lo"),
                        rs.getString("category") 
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isDuplicate(Restaurant restaurant) {
        String SQL = "SELECT COUNT(*) FROM restaurant WHERE name = ? AND address = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getAddress());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertRestaurant(Restaurant restaurant) {
        if (isDuplicate(restaurant)) {
            return;
        }

        String SQL = "INSERT INTO restaurant (region, name, address, phone, la, lo, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, restaurant.getRegion());
            pstmt.setString(2, restaurant.getName());
            pstmt.setString(3, restaurant.getAddress());
            pstmt.setString(4, restaurant.getPhone());
            pstmt.setDouble(5, restaurant.getLatitude());
            pstmt.setDouble(6, restaurant.getLongitude());
            pstmt.setString(7, restaurant.getCategory());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Restaurant> getRestaurantsByCategory(String category) {
        List<Restaurant> list = new ArrayList<>();
        String SQL = "SELECT * FROM restaurant WHERE category = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Restaurant(
                        rs.getString("region"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getDouble("la"),
                        rs.getDouble("lo"),
                        rs.getString("category")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Restaurant> getRecommendRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String SQL = "SELECT * FROM restaurant";
        try (PreparedStatement pstmt = conn.prepareStatement(SQL);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(new Restaurant(
                    rs.getString("region"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("phone"),
                    rs.getDouble("la"),
                    rs.getDouble("lo"),
                    rs.getString("category")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
