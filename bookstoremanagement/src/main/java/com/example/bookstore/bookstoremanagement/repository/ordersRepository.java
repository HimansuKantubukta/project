package com.example.bookstore.bookstoremanagement.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.entity.Orders;

public interface ordersRepository extends JpaRepository<Orders,Integer>{

//	List<Orders> findByCustId( Customers custId);

}
