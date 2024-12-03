package review;

public class Review {
	
	private Long reviewId;
	private String title;
	private String content;
	private double rating;
	private Long userId;
	private Long restaurantId;
	private String createdDate;
	
	public Review() {
		super();
	}
	
	public Long getReviewId() {
		return reviewId;
	}
	
	public void setReviewId(Long id) {
		this.reviewId = id;
	}
	
	public Long getRestaurantId() {
		return restaurantId;
	}
	
	public void setRestaurantId(Long restaurantId) {
		this.restaurantId = restaurantId;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public void setRating(double rating) {
		this.rating = rating;
	}
	
	public double getRating() {
		return rating;
	}
	
	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
}
