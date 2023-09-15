package com.example.bookstore.bookstoremanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bookstore.bookstoremanagement.entity.Inventory;

public interface InventoryRepository extends JpaRepository<Inventory,Integer>

	 
{

}
