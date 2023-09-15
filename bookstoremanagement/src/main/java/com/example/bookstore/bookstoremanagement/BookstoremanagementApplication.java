package com.example.bookstore.bookstoremanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.CrossOrigin;


@CrossOrigin
@SpringBootApplication
public class BookstoremanagementApplication {

	public static void main(String[] args) {
		SpringApplication.run(BookstoremanagementApplication.class, args);
	}

}
