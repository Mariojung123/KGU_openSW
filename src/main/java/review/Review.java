package review;

import User.User;

public class Review {
	
	private Long reviewId;
	private String title;
	private String content;
	private User user;
	private String createdDate;
	
	public Review() {
		super();
	}
	
	public Long getId() {
		return reviewId;
	}
	
	public void setId(Long id) {
		this.reviewId = id;
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
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
}
