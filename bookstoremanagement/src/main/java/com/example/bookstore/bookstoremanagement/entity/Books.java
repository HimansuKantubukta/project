package com.example.bookstore.bookstoremanagement.entity;

import java.sql.Date;

import org.springframework.web.bind.annotation.Mapping;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name="Books")
public class Books 
{
	@Id
	@Column(name="book_id")
	private int bookId;
	
	@Column(name="booktitle")
	private String title;
	
	@Column(name="category")
	private String category;
	
	@Column(name="book_price")
	private int price;
	
	
	

    @ManyToOne()
    @JoinColumn(name="auth_id")
    private Author authorId; 
    
    @Column(name="created_date")
    private Date date;
    
    @Column(name="imglink")
    private String link;
 

	public Books() {
	}


	public Books(int book_id, String title, String category, int price, Author authorId, Date date,
			String link) {
		super();
		this.bookId = book_id;
		this.title = title;
		this.category = category;
		this.price = price;
		this.authorId = authorId;
		this.date = date;
		this.link = link;
	}


	public int getBook_id() {
		return bookId;
	}


	public void setBook_id(int book_id) {
		this.bookId = book_id;
	}


	public String getTitle() {
		return title;
	}


	public void setTitle(String title) {
		this.title = title;
	}


	public String getCategory() {
		return category;
	}


	public void setCategory(String category) {
		this.category = category;
	}


	public int getPrice() {
		return price;
	}


	public void setPrice(int price) {
		this.price = price;
	}




	public Author getAuthorId() {
		return authorId;
	}


	public void setAuthorId(Author authorId) {
		this.authorId = authorId;
	}


	public Date getDate() {
		return date;
	}


	public void setDate(Date date) {
		this.date = date;
	}


	public String getLink() {
		return link;
	}


	public void setLink(String link) {
		this.link = link;
	}
}
