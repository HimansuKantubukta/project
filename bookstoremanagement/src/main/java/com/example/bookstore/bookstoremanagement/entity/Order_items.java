// This is the package declaration for the entity class.
package com.example.bookstore.bookstoremanagement.entity;

// Import necessary annotations from the Jakarta Persistence API.
import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

// Define the entity class named "Order_items."
@Entity
@Table(name="order_items")
public class Order_items
{
    // Declare the primary key field for Order_items, annotated with @Id and generated using Identity strategy.
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="item_id")
    private int itemId;
    
    // Declare a field for the order ID.
    @Column(name="order_id")
    private int orderId;
    
    // Declare a field for the customer ID.
    @Column(name="cust_id")
    private int customer_id;
    
    // Declare a field for the book ID.
    @Column(name="book_id")
    private int bookId;
    
    // Declare a field for the order date.
    @Column(name="order_date")
    private String order_date;

    // Default constructor for Order_items.
    public Order_items() {}

    // Parameterized constructor for Order_items.
    public Order_items(int itemId, int orderId, int customer_id, int bookId, String order_date) {
        this.itemId = itemId;
        this.orderId = orderId;
        this.customer_id = customer_id;
        this.bookId = bookId;
        this.order_date = order_date;
    }

    // Getter method for itemId.
    public int getItemId() {
        return itemId;
    }

    // Setter method for itemId.
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    // Getter method for orderId.
    public int getOrderId() {
        return orderId;
    }

    // Setter method for orderId.
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    // Getter method for customer_id.
    public int getCustomer_id() {
        return customer_id;
    }

    // Setter method for customer_id.
    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    // Getter method for bookId.
    public int getBookId() {
        return bookId;
    }

    // Setter method for bookId.
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    // Getter method for order_date.
    public String getOrder_date() {
        return order_date;
    }

    // Setter method for order_date.
    public void setOrder_date(String order_date) {
        this.order_date = order_date;
    }
    
   
}
