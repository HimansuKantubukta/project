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

    private int customerId;

    @Column(name="order_date")

    private String orderDate;

    @Column(name="total_amount_after_tax")
    private int totalmoney;

    public Orders() {}

	public Orders(int orderId, int customerId, String orderDate, int totalmoney) {
		super();
		this.orderId = orderId;
		this.customerId = customerId;
		this.orderDate = orderDate;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public int getTotalmoney() {
		return totalmoney;
	}

	public void setTotalmoney(int totalmoney) {
		this.totalmoney = totalmoney;
	}
}

    