package com.example.bookstore.bookstoremanagement.entity;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name="Author")
public class Author 
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="auth_id")
	private int AuthorId;
	
	@Column(name="Auth_name")
	private String AuthorName;
	
	@Column(name="Auth_country")
	private String Country;
	
	@Column(name="created_date")
	private String CreatedDate;

	public Author() {
		super();
	}

	public Author(int author_id, String author_name, String country, String created_date) {
		super();
		AuthorId = author_id;
		AuthorName = author_name;
		Country = country;
		CreatedDate = created_date;
	}

	public int getAuthor_id() {
		return AuthorId;
	}

	public void setAuthor_id(int author_id) {
		AuthorId = author_id;
	}

	public String getAuthor_name() {
		return AuthorName;
	}

	public void setAuthor_name(String author_name) {
		AuthorName = author_name;
	}

	public String getCountry() {
		return Country;
	}

	public void setCountry(String country) {
		Country = country;
	}

	public String getCreated_date() {
		return CreatedDate;
	}

	public void setCreated_date(String created_date)
	{
		CreatedDate = created_date;
	}
	
	
}


