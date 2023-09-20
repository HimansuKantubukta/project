// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;
// Import the Spring stereotype annotation for repository.
import org.springframework.stereotype.Repository;

// Import the Bucket and Customers entities that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.Bucket;
import com.example.bookstore.bookstoremanagement.entity.Customers;

// Define the BucketRepository interface that extends JpaRepository for Bucket entities.
@Repository
public interface BucketRepository extends JpaRepository<Bucket, Integer> {
    
    // List<Bucket> findByCustomer_id(Customers customer_id);
}
