package com.example.bookstore.bookstoremanagement.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

import com.example.bookstore.bookstoremanagement.entity.Customers;

public interface CustomersRepository extends JpaRepository<Customers,Integer>
{
	@Procedure("customer_signup")
	void insertinto(
			@Param("cust_name") String name,
			@Param("cust_mobile") long mobile,
			@Param("emailId") String emailId,
			@Param("postal_code") int postal_code,
			@Param("state") String state,
			@Param("password") String password,
			@Param("createdat") LocalDate date
			);

	Customers findCustomersByEmailIdAndPassword(String emailId, String password);
}
