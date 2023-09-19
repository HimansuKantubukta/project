package com.example.bookstore.bookstoremanagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;

// Define this class as an entity in JPA
@Entity
// Specify the table name
@Table(name="customers")
public class Customers {
    // Define the primary key for this entity
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="cust_id")
    private int customer_id;

    // Map this field to the 'cust_name' column in the table
    @Column(name="cust_name")
    private String customerName;

    // Map this field to the 'cust_mobile' column in the table
    @Column(name="cust_mobile")
    private long mobile;

    // Map this field to the 'email_id' column in the table
    @Column(name="email_id")
    private String emailId;

    // Map this field to the 'postal_code' column in the table
    @Column(name="postal_code")
    private int postalCode;

    // Map this field to the 'state' column in the table
    @Column(name="state")
    private String stateName;

    // Map this field to the 'password' column in the table
    @Column(name="password")
    private String password;

    // Map this field to the 'createdat' column in the table
    @Column(name="createdat")
    private LocalDate date;

    // Default constructor (required by JPA)
    public Customers() {}

    // Constructor with parameters
    public Customers(int customer_id, String customerName, long mobile, String emailId,
            int postalCode, String stateName, String password, LocalDate date) {
        super();
        this.customer_id = customer_id;
        this.customerName = customerName;
        this.mobile = mobile;
        this.emailId = emailId;
        this.postalCode = postalCode;
        this.stateName = stateName;
        this.password = password;
        this.date = date;
    }

    // Getter for customer_id
    public int getCustomer_id() {
        return customer_id;
    }

    // Setter for customer_id
    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    // Getter for customerName
    public String getCustomerName() {
        return customerName;
    }

    // Setter for customerName
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    // Getter for mobile
    public long getMobile() {
        return mobile;
    }

    // Setter for mobile
    public void setMobile(long mobile) {
        this.mobile = mobile;
    }

    // Getter for emailId
    public String getEmailId() {
        return emailId;
    }

    // Setter for emailId
    public void setEmailId(String emailId) {
        this.emailId = emailId;
    }

    // Getter for postalCode
    public int getPostalCode() {
        return postalCode;
    }

    // Setter for postalCode
    public void setPostalCode(int postalCode) {
        this.postalCode = postalCode;
    }

    // Getter for stateName
    public String getStateName() {
        return stateName;
    }

    // Setter for stateName
    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    // Getter for password
    public String getPassword() {
        return password;
    }

    // Setter for password
    public void setPassword(String password) {
        this.password = password;
    }

    // Getter for date
    public LocalDate getDate() {
        return date;
    }

    // Setter for date
    public void setDate(LocalDate date) {
        this.date = date;
    }
}
