package com.example.bookstore.bookstoremanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import com.example.bookstore.bookstoremanagement.entity.Payments;

public interface PaymentsRepository extends JpaRepository<Payments,Integer> {
	  @Procedure(procedureName = "makepayment")
	  void makePayment(int custId);

	}


