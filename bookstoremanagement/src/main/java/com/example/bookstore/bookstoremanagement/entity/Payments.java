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

// Define the entity class named "Payments."
@Entity
@Table(name="payments")
public class Payments
{
    // Declare the primary key field for Payments, annotated with @Id and generated using Identity strategy.
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="pay_id")
    private int paymentId;
    
    // Declare a field for the customer ID.
    @Column(name="cust_id")
    private int customer_id;
    
    // Declare a field for the order date.
    @Column(name="order_date")
    private String order_date;
    
    // Declare a field for the tax amount.
    @Column(name="tax")
    private int taxmoney;
    
    // Declare a field for the total amount.
    @Column(name="total")
    private int totalmoney;

    // Default constructor for Payments.
    public Payments() {}

    // Parameterized constructor for Payments.
    public Payments(int paymentId, int customer_id, String order_date, int taxmoney, int totalmoney) {
        this.paymentId = paymentId;
        this.customer_id = customer_id;
        this.order_date = order_date;
        this.taxmoney = taxmoney;
        this.totalmoney = totalmoney;
    }

    // Getter method for paymentId.
    public int getPaymentId() {
        return paymentId;
    }

    // Setter method for paymentId.
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
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

    // Getter method for taxmoney.
    public int getTaxmoney() {
        return taxmoney;
    }

    // Setter method for taxmoney.
    public void setTaxmoney(int taxmoney) {
        this.taxmoney = taxmoney;
    }

    // Getter method for totalmoney.
    public int getTotalmoney() {
        return totalmoney;
    }

    // Setter method for totalmoney.
    public void setTotalmoney(int totalmoney) {
        this.totalmoney = totalmoney;
    }
    
    // The following section is commented out. You can uncomment it when needed.
    
    // Uncomment this section if you want to establish a OneToOne relationship with the Customers entity.
//    @OneToOne
//    @JoinColumn(name="cus_id")
//    private Customers customer;
}
