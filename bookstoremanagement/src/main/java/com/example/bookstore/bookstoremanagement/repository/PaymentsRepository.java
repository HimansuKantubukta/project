// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

// Import the Payments entity that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.Payments;

// Define the PaymentsRepository interface that extends JpaRepository for Payments entities.
public interface PaymentsRepository extends JpaRepository<Payments, Integer> {
    
    // Custom stored procedure call to make a payment.
    @Procedure(procedureName = "makepayment")
    void makePayment(int custId);
}


