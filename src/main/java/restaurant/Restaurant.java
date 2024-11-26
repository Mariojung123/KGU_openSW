package restaurant;

public class Restaurant {
    private String region;
    private String name;
    private String address;
    private String phone;
    private double latitude;
    private double longitude;

    public Restaurant() {}

    public Restaurant(String region, String name, String address, String phone, double latitude, double longitude) {
        this.region = region;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String getRegion() { return region; }
    public String getName() { return name; }
    public String getAddress() { return address; }
    public String getPhone() { return phone; }
    public double getLatitude() { return latitude; }
    public double getLongitude() { return longitude; }

    // Setter 메서드 (필수)
    public void setRegion(String region) { this.region = region; }
    public void setName(String name) { this.name = name; }
    public void setAddress(String address) { this.address = address; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
}
