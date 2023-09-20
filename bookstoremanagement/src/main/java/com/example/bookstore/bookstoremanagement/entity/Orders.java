// This is the package declaration for the entity class.
package com.example.bookstore.bookstoremanagement.entity;

// Import necessary annotations from the Jakarta Persistence API.
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

// Define the entity class named "Orders."
@Entity
@Table(name="orders")
public class Orders
{
    // Declare the primary key field for Orders, annotated with @Id and generated using Identity strategy.
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="order_id", nullable = false)
    private int orderId;
    
    // Declare a field for the customer ID.
    @Column(name="cust_id")
    private int customer_id;
    
    // Declare a field for the order date.
    @Column(name="order_date")
    private String order_date;
    
    // Declare a field for the total amount after tax.
    @Column(name="totalamountaftertax")
    private int totalmoney;

    // Default constructor for Orders.
    public Orders() {}

    // Parameterized constructor for Orders.
    public Orders(int orderId, int customer_id, String order_date, int totalmoney) {
        this.orderId = orderId;
        this.customer_id = customer_id;
        this.order_date = order_date;
        this.totalmoney = totalmoney;
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

    // Getter method for order_date.
    public String getOrder_date() {
        return order_date;
    }

    // Setter method for order_date.
    public void setOrder_date(String order_date) {
        this.order_date = order_date;
    }

    // Getter method for totalmoney.
    public int getTotalmoney() {
        return totalmoney;
    }

    // Setter method for totalmoney.
    public void setTotalmoney(int totalmoney) {
        this.totalmoney = totalmoney;
    }
   
}
