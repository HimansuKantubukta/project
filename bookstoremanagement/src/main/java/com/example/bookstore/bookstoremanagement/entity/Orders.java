package com.example.bookstore.bookstoremanagement.entity;
import jakarta.persistence.Column;

import jakarta.persistence.Entity;

import jakarta.persistence.GeneratedValue;

import jakarta.persistence.GenerationType;

import jakarta.persistence.Id;

import jakarta.persistence.JoinColumn;

import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

 

@Entity

@Table(name="orders")

public class Orders

{

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)

    @Column(name="order_id",nullable = false)

    private int orderId;

    @Column(name="cust_id")

    private int customer_id;

    @Column(name="order_date")

    private String order_date;

    @Column(name="totalamountaftertax")

    private int totalmoney;

    public Orders() {}

    public Orders(int orderId, int customer_id, String order_date, int totalmoney) {

        this.orderId = orderId;

        this.customer_id = customer_id;

        this.order_date = order_date;

        this.totalmoney = totalmoney;

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

    public String getOrder_date() {

        return order_date;

    }

    public void setOrder_date(String order_date) {

        this.order_date = order_date;

    }

    public int getTotalmoney() {

        return totalmoney;

    }

    public void setTotalmoney(int totalmoney) {

        this.totalmoney = totalmoney;

    }

    

//    @OneToOne
//
//    @JoinColumn(name="cus_id")
//
//    private Customers customer;

    

}
