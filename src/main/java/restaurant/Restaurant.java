package restaurant;

public class Restaurant {
	private Long restaurantId;
    private String region;
    private String name;
    private String address;
    private String phone;
    private double la;
    private double lo;

    public Restaurant() {}

    public Restaurant(String region, String name, String address, String phone, double la, double lo) {
        this.region = region;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.la = la;
        this.lo = lo;
    }
    
    public Long getRestaurantId() { return restaurantId; }
    public String getRegion() { return region; }
    public String getName() { return name; }
    public String getAddress() { return address; }
    public String getPhone() { return phone; }
    public double getLatitude() { return la; }
    public double getLongitude() { return lo; }
    
    public void setRestaurantId(Long restaurantId) { this.restaurantId = restaurantId; }
    public void setRegion(String region) { this.region = region; }
    public void setName(String name) { this.name = name; }
    public void setAddress(String address) { this.address = address; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setLatitude(double latitude) { this.la = latitude; }
    public void setLongitude(double longitude) { this.lo = longitude; }
}