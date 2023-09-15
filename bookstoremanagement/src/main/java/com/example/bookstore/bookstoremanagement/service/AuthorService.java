package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Author;
import com.example.bookstore.bookstoremanagement.repository.AuthorRepository;

@Service
public class AuthorService 
{
	@Autowired
	AuthorRepository authorRepository;
	
	  @Transactional(readOnly=true)

	     public List<Author> getAllAuthors(){

	          return authorRepository.findAll();

	     

	     }

	     @Transactional(readOnly=true)

	     public Author getAuthorsById(int Author_id) {

	    Optional<Author> at= authorRepository.findById(Author_id);

	    if(at.isPresent())

	        return at.get();

	    return null;

	     }

	     

	      @Transactional

	      public boolean insertIntoAuthors(Author author) {

	        return authorRepository.save(author)!=null;

	          

	      }

	      

	    @Transactional

	    public boolean deletByauthorId(int Author_id) {

	         long count=authorRepository.count();

	         authorRepository.deleteById(Author_id);

	            return count> authorRepository.count();

	    }

	}
	
	
	


