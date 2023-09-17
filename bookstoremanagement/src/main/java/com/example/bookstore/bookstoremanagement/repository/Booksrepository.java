package com.example.bookstore.bookstoremanagement.repository;


import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import com.example.bookstore.bookstoremanagement.entity.Author;
import com.example.bookstore.bookstoremanagement.entity.Books;

public interface Booksrepository extends JpaRepository<Books,Integer>
{
	@Procedure("insert_into_books")
	void insertinto(
			@Param("book_id") int bookId,
			@Param("booktitle") String title,
			@Param("category") String category,
			@Param("book_price") int price,
			@Param("auth_id") int authorId,
			@Param("quantity") int quantity,
			@Param("imglink") String link
			);
			
	
	
	

	
	
	
	
	
	
//	List<Books> findByTitle(String title);

	@Query("SELECT b FROM Books b WHERE b.title LIKE :name OR b.category LIKE  :name")
    List<Books> searchBook(
        @Param("name") String name
    );	
	

	
}







