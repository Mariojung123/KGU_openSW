package review;


public class ReviewDTO {
	private Long reviewId;
	private String title;
	private String content;
	private double rating;
	
	public Long getReviewId() {
		return reviewId;
	}
	
	public void setReviewId(Long reviewId) {
		this.reviewId = reviewId;
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
	
	public double getRating() {
		return rating;
	}
	
	public void setRating(double rating) {
		this.rating = rating;
	}
}
