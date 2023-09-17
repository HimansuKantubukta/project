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
@Table(name="payments")


public class Payments

{

 

        @Id

        @GeneratedValue(strategy=GenerationType.IDENTITY)

        @Column(name="pay_id")

        private int paymentId;

        @Column(name="cust_id")

        private int customerId;

        @Column(name="order_date")

        private String orderDate;

        @Column(name="tax")

        private int taxmoney;

        @Column(name="total")

        private int totalmoney;

        public Payments() {}

        public Payments(int paymentId, int customer_id, String order_date, int taxmoney, int totalmoney) {

            this.paymentId = paymentId;

            this.customerId = customer_id;

            this.orderDate = order_date;

            this.taxmoney = taxmoney;

            this.totalmoney = totalmoney;

        }

        public int getPaymentId() {

            return paymentId;

        }

        public void setPaymentId(int paymentId) {

            this.paymentId = paymentId;

        }

        public int getCustomer_id() {

            return customerId;

        }

        public void setCustomer_id(int customer_id) {

            this.customerId = customer_id;

        }

        public String getOrder_date() {

            return orderDate;

        }

        public void setOrder_date(String order_date) {

            this.orderDate = order_date;

        }

        public int getTaxmoney() {

            return taxmoney;

        }

        public void setTaxmoney(int taxmoney) {

            this.taxmoney = taxmoney;

        }

        public int getTotalmoney() {

            return totalmoney;

        }

        public void setTotalmoney(int totalmoney) {

            this.totalmoney = totalmoney;

        }

        

        

//        @OneToOne
//
//        @JoinColumn(name="cus_id")
//
//        private Customers customer;

        

 

}
