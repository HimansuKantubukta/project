// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;

// Import the admins entity that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.admins;

// Define the adminsRepository interface that extends JpaRepository for admins entities.
public interface adminsRepository extends JpaRepository<admins, Integer> {
    
    // Custom query method to find an admin by email and password.
    admins findAdminIdByEmailAndPassword(String email, String password);
}
