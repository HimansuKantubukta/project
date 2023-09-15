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
			@Param("email_id") String emailId,
			@Param("postal_code") int postal_code,
			@Param("state") String state,
			@Param("password") String password,
			@Param("createdat") LocalDate date
			);

//	@Query("SELECT c FROM Customers c WHERE c.email_id = :email_id AND c.password = :password")
//
//    Customers validateLogin(
//
//        @Param("email_id") String email,
//
//        @Param("password") String password
//
//    );
	
//	@Query(nativeQuery = true,value = "select * from customers where email_id =:email and password =:password")
//	  Customers findByEmail_idAndPassword(String email, String password);

	Customers findCustomersByEmailIdAndPassword(String emailId, String password);
}
