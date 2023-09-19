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
	// Generate the ID value automatically
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	// Map this field to the 'auth_id' column in the table
	@Column(name="auth_id")
	private int Author_id;
	
	// Map this field to the 'Auth_name' column in the table
	@Column(name="Auth_name")
	private String Author_name;
	
	// Map this field to the 'Auth_country' column in the table
	@Column(name="Auth_country")
	private String Country;
	
	// Map this field to the 'created_date' column in the table
	@Column(name="created_date")
	private String Created_date;

	public Author() {
		super();
	}

	// Constructor with parameters
	public Author(int author_id, String author_name, String country, String created_date) {
		super();
		Author_id = author_id;
		Author_name = author_name;
		Country = country;
		Created_date = created_date;
	}

	// Getter for Author_id
	public int getAuthor_id() {
		return Author_id;
	}

	// Setter for Author_id
	public void setAuthor_id(int author_id) {
		Author_id = author_id;
	}

	// Getter for Author_name
	public String getAuthor_name() {
		return Author_name;
	}

	// Setter for Author_name
	public void setAuthor_name(String author_name) {
		Author_name = author_name;
	}

	// Getter for Country
	public String getCountry() {
		return Country;
	}

	// Setter for Country
	public void setCountry(String country) {
		Country = country;
	}

	// Getter for Created_date
	public String getCreated_date() {
		return Created_date;
	}

	// Setter for Created_date
	public void setCreated_date(String created_date)
	{
		Created_date = created_date;
	}
}
