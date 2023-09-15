package com.example.bookstore.bookstoremanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.bookstore.bookstoremanagement.entity.admins;



public interface adminsRepository extends JpaRepository<admins, Integer>{
	admins findAdminIdByEmailAndPassword(String email, String password);
}