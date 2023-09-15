package com.example.bookstore.bookstoremanagement.controller;

import java.util.List;

 

 

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;

import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.CrossOrigin;

import org.springframework.web.bind.annotation.DeleteMapping;

import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.web.bind.annotation.PathVariable;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestBody;

import org.springframework.web.bind.annotation.RequestMapping;


import org.springframework.web.bind.annotation.RestController;

import com.example.bookstore.bookstoremanagement.entity.Orders;
import com.example.bookstore.bookstoremanagement.service.OrdersService;

 


 

@CrossOrigin(origins= {"http://localhost:4200"},allowCredentials="true")

@RequestMapping("/Orders")

@RestController

public class OrdersController 

{

	@Autowired
	OrdersService orderService;


	@GetMapping(value="/f/",produces="application/json")

	 public ResponseEntity<List<Orders>>getallitems()

	 {

		  List<Orders> t1=orderService.getAlldetails();

		  if(t1.size()!=0)

			return new ResponseEntity<List<Orders>>(t1,HttpStatus.OK);

			  return new ResponseEntity<List<Orders>>(t1,HttpStatus.NOT_FOUND);


	 }

	 @GetMapping(value="/",produces="application/Json")
	 public ResponseEntity<Orders> getOrderById(int Orderid) {

		 Orders or=orderService.getoredresbyId(Orderid);

			if(or!=null)

				return new ResponseEntity<Orders>(or,HttpStatus.OK);

			return new ResponseEntity<Orders>(or,HttpStatus.NOT_FOUND);

	 }

	  @PostMapping(consumes="application/Json")
	  public HttpStatus insertintoOrders(@RequestBody Orders order) {

		if(orderService.insertOrmodify(order))

			 return HttpStatus.OK;

			 return HttpStatus.NOT_MODIFIED;


	  }

		 @DeleteMapping("/{orderId}")
		 public HttpStatus deleteOrder(@PathVariable int orderid)

		 {

			 if(orderService.deleteByid(orderid))

				 return HttpStatus.OK;

			 return HttpStatus.NOT_FOUND;

		 }

 

}