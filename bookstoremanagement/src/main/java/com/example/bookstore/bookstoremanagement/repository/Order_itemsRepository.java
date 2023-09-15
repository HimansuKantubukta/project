package com.example.bookstore.bookstoremanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bookstore.bookstoremanagement.entity.Order_items;

public interface Order_itemsRepository  extends JpaRepository<Order_items,Integer>
{

}
