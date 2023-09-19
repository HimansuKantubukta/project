package com.example.bookstore.bookstoremanagement.entity;

import java.sql.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

// Define this class as an entity in JPA
@Entity
// Specify the table name
@Table(name="Books")
public class Books 
{
    // Define the primary key for this entity
    @Id
    @Column(name="book_id")
    private int book_id;
    
    // Map this field to the 'booktitle' column in the table
    @Column(name="booktitle")
    private String title;
    
    // Map this field to the 'category' column in the table
    @Column(name="category")
    private String category;
    
    // Map this field to the 'book_price' column in the table
    @Column(name="book_price")
    private int price;
    
    // Map this field to the 'book_ISBN' column in the table
    @Column(name="book_ISBN")
    private long isbn;
    
    // Define a Many-to-One relationship with the Author entity using 'auth_id' as the foreign key
    @ManyToOne()
    @JoinColumn(name="auth_id")
    private Author authorId; 
    
    // Map this field to the 'created_date' column in the table
    @Column(name="created_date")
    private Date date;
    
    // Map this field to the 'imglink' column in the table
    @Column(name="imglink")
    private String link;

    // Default constructor (required by JPA)
    public Books() {
    }

    // Constructor with parameters
    public Books(int book_id, String title, String category, int price, long isbn, Author authorId, Date date,
            String link) {
        super();
        this.book_id = book_id;
        this.title = title;
        this.category = category;
        this.price = price;
        this.isbn = isbn;
        this.authorId = authorId;
        this.date = date;
        this.link = link;
    }

    // Getter for book_id
    public int getBook_id() {
        return book_id;
    }

    // Setter for book_id
    public void setBook_id(int book_id) {
        this.book_id = book_id;
    }

    // Getter for title
    public String getTitle() {
        return title;
    }

    // Setter for title
    public void setTitle(String title) {
        this.title = title;
    }

    // Getter for category
    public String getCategory() {
        return category;
    }

    // Setter for category
    public void setCategory(String category) {
        this.category = category;
    }

    // Getter for price
    public int getPrice() {
        return price;
    }

    // Setter for price
    public void setPrice(int price) {
        this.price = price;
    }

    // Getter for isbn
    public long getIsbn() {
        return isbn;
    }

    // Setter for isbn
    public void setIsbn(long isbn) {
        this.isbn = isbn;
    }

    // Getter for authorId (Author entity)
    public Author getAuthorId() {
        return authorId;
    }

    // Setter for authorId (Author entity)
    public void setAuthorId(Author authorId) {
        this.authorId = authorId;
    }

    // Getter for date
    public Date getDate() {
        return date;
    }

    // Setter for date
    public void setDate(Date date) {
        this.date = date;
    }

    // Getter for link
    public String getLink() {
        return link;
    }

    // Setter for link
    public
