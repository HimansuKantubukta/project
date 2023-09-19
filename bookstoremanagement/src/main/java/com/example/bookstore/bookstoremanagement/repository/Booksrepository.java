package com.example.bookstore.bookstoremanagement.repository;


import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.bookstore.bookstoremanagement.entity.Books;

public interface Booksrepository extends JpaRepository<Books,Integer>
{
	
//	List<Books> findByTitle(String title);

	@Query("SELECT b FROM Books b WHERE b.title LIKE :name OR b.category LIKE  :name")
    List<Books> searchBook(
        @Param("name") String name
    );	
	

	
}







