// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

// Import necessary Java time library.
import java.time.LocalDate;

// Import the Customers entity that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.Customers;

// Define the CustomersRepository interface that extends JpaRepository for Customers entities.
public interface CustomersRepository extends JpaRepository<Customers, Integer> {
    
    // Custom stored procedure call to insert customer data.
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

    // Custom query method to find customers by emailId and password.
    Customers findCustomersByEmailIdAndPassword(String emailId, String password);
}
