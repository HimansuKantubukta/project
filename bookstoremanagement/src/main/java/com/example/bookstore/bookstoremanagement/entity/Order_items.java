package com.example.bookstore.bookstoremanagement.entity;

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

 

@Entity
@Table(name="order_items")

public class Order_items

{

    @Id

    @GeneratedValue(strategy=GenerationType.IDENTITY)

    @Column(name="item_id")

    private int itemId;

    @Column(name="order_id")

    private int orderId;

    @Column(name="cust_id")

    private int customer_id;

    @Column(name="book_id")

    private int bookId;

    @Column(name="order_date")

    private String order_date;

    public Order_items() {}

    public Order_items(int itemId, int orderId, int customer_id, int bookId, String order_date) {

        this.itemId = itemId;

        this.orderId = orderId;

        this.customer_id = customer_id;

        this.bookId = bookId;

        this.order_date = order_date;

    }

    public int getItemId() {

        return itemId;

    }

    public void setItemId(int itemId) {

        this.itemId = itemId;

    }

    public int getOrderId() {

        return orderId;

    }

    public void setOrderId(int orderId) {

        this.orderId = orderId;

    }

    public int getCustomer_id() {

        return customer_id;

    }

    public void setCustomer_id(int customer_id) {

        this.customer_id = customer_id;

    }

    public int getBookId() {

        return bookId;

    }

    public void setBookId(int bookId) {

        this.bookId = bookId;

    }

    public String getOrder_date() {

        return order_date;

    }

    public void setOrder_date(String order_date) {

        this.order_date = order_date;

    }

    

    

//    @OneToOne
//
//    @JoinColumn(name="cus_id")
//
//    private Customers customer;
//
//    
//
//    @OneToOne
//
//    @JoinColumn(name="order_id")
//
//    private Orders order;
//
//    
//
//    @OneToMany(mappedBy="book_id")
//
//    private List<Books> book;

    

    

}