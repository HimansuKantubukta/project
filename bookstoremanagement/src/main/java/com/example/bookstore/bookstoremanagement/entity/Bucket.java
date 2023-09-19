package com.example.bookstore.bookstoremanagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

// Define this class as an entity in JPA
@Entity
// Specify the table name
@Table(name="bucket")
public class Bucket
{
    // Define the primary key for this entity
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="bucket_id")
    private int bucketId;

    // Define a Many-to-One relationship with the Books entity using 'book_id' as the foreign key
    @ManyToOne
    @JoinColumn(name="book_id")
    private Books book_id;

    // Define a Many-to-One relationship with the Customers entity using 'cust_id' as the foreign key
    @ManyToOne()
    @JoinColumn(name="cust_id")
    private Customers customer_id;

    // Map this field to the 'price' column in the table
    @Column(name="price")
    private int bookprice;

    // Map this field to the 'quantity' column in the table
    @Column(name="quantity")
    private int quantity;

    // Default constructor (required by JPA)
    public Bucket() {}

    // Constructor with parameters
    public Bucket(int bucketId, Books book_id, Customers customer_id, int bookprice, int quantity) {
        this.bucketId = bucketId;
        this.book_id = book_id;
        this.customer_id = customer_id;
        this.bookprice = bookprice;
        this.quantity = quantity;
    }

    // Getter for bucketId
    public int getBucketId() {
        return bucketId;
    }

    // Setter for bucketId
    public void setBucketId(int bucketId) {
        this.bucketId = bucketId;
    }

    // Getter for book_id (Books entity)
    public Books getBook_id() {
        return book_id;
    }

    // Setter for book_id (Books entity)
    public void setBook_id(Books book_id) {
        this.book_id = book_id;
    }

    // Getter for customer_id (Customers entity)
    public Customers getCustomer_id() {
        return customer_id;
    }

    // Setter for customer_id (Customers entity)
    public void setCustomer_id(Customers customer_id) {
        this.customer_id = customer_id;
    }

    // Getter for bookprice
    public int getBookprice() {
        return bookprice;
    }

    // Setter for bookprice
    public void setBookprice(int bookprice) {
        this.bookprice = bookprice;
    }

    // Getter for quantity
    public int getQuantity() {
        return quantity;
    }

    // Setter for quantity
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
