package com.example.bookstore.bookstoremanagement.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.bookstore.bookstoremanagement.entity.Books;
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.Booksrepository;
import com.example.bookstore.bookstoremanagement.repository.CustomersRepository;
import com.example.bookstore.bookstoremanagement.service.booksService;

import jakarta.servlet.http.HttpSession;

	@RequestMapping("/book")
	@CrossOrigin(origins= {"http://localhost:4200"},allowCredentials = "true")
	@RestController
	@Transactional(readOnly = true)
	public class BookController

	{

	    @Autowired
	    booksService booksService; 
	    

	    @GetMapping(value="/all",produces="application/json")

	     public ResponseEntity<List<Books>>getAllBooks(HttpSession session)

	     {
	    	System.out.println(session.getAttribute("id"));
	          List<Books> t1=booksService.getAllBooks();

	          if(t1.size()!=0)

	            return new ResponseEntity<List<Books>>(t1,HttpStatus.OK);

	              return new ResponseEntity<List<Books>>(t1,HttpStatus.NOT_FOUND);

	        

	     }


	
//	     @GetMapping(value="/title/{book_title}")
//	      public List<Books> Bookdeatils(@PathVariable String book_title)
//	      {
////	    	 System.out.println("Check Point 1 ------------->>>>>>>>>>>>>>>>>>> "+book_title);
//	    	 List<Books> listBook = Booksrepository.viewinto(book_title);
//	    	 return listBook;
//	      }
//	     @GetMapping(value="/{auth_id}")
//	      public List<Books> findbookByAuth_id(@PathVariable  int auth_id)
//	      {
//	    	 List<Books> listBook=  Booksrepository.view_by_Author(auth_id);
//			return listBook; 
//	      }
//	     @GetMapping(value="/cat/{book_category}")
//	      public List<Books> findByCategeroy(@PathVariable  String book_category)
//	      {
//	    	 List<Books> booklist=Booksrepository.view_by_category(book_category);
//	    	 return booklist;
//	      }

	    

	    
	 	     

	     @GetMapping(value="/search/{name}")

	 	public List<Books> searchingBooks(@PathVariable String name) 
	     {
	         return booksService.searchBooksBy("%"+name+"%");
	
	 	}

	}
	

	 




