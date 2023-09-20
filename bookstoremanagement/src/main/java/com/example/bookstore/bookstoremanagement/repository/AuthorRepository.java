// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;

// Import the Author entity that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.Author;

// Define the AuthorRepository interface that extends JpaRepository for Author entities.
public interface AuthorRepository extends JpaRepository<Author, Integer> {
    // No additional code is added here since this interface simply extends JpaRepository.
}
