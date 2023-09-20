// This is the package declaration for the repository interface.
package com.example.bookstore.bookstoremanagement.repository;

// Import necessary Spring Data JPA repository interface.
import org.springframework.data.jpa.repository.JpaRepository;
// Import necessary annotations and classes for custom query.
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

// Import the Books entity that this repository is associated with.
import com.example.bookstore.bookstoremanagement.entity.Books;

// Define the Booksrepository interface that extends JpaRepository for Books entities.
public interface Booksrepository extends JpaRepository<Books, Integer> {
    
    // Custom query to search for books by title or category using a SQL-like query.
    @Query("SELECT b FROM Books b WHERE b.title LIKE :name OR b.category LIKE  :name")
    List<Books> searchBook(
        @Param("name") String name
    );
}
