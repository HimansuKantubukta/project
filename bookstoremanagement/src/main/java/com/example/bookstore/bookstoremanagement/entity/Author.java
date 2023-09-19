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
	private int Author_id;
	
	@Column(name="Auth_name")
	private String Author_name;
	
	@Column(name="Auth_country")
	private String Country;
	
	@Column(name="created_date")
	private String Created_date;

	public Author() {
		super();
	}

	public Author(int author_id, String author_name, String country, String created_date) {
		super();
		Author_id = author_id;
		Author_name = author_name;
		Country = country;
		Created_date = created_date;
	}

	public int getAuthor_id() {
		return Author_id;
	}

	public void setAuthor_id(int author_id) {
		Author_id = author_id;
	}

	public String getAuthor_name() {
		return Author_name;
	}

	public void setAuthor_name(String author_name) {
		Author_name = author_name;
	}

	public String getCountry() {
		return Country;
	}

	public void setCountry(String country) {
		Country = country;
	}

	public String getCreated_date() {
		return Created_date;
	}

	public void setCreated_date(String created_date)
	{
		Created_date = created_date;
	}
	
	
}


