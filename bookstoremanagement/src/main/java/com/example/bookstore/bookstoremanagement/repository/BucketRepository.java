package com.example.bookstore.bookstoremanagement.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.bookstore.bookstoremanagement.entity.Bucket;
import com.example.bookstore.bookstoremanagement.entity.Customers;
@Repository
public interface BucketRepository extends JpaRepository<Bucket,Integer>
{
		
//		List<Bucket> findByCustomer_id( Customers customer_id);

}
