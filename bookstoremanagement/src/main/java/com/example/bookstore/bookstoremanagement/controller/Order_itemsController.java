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
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.bookstore.bookstoremanagement.entity.Order_items;
import com.example.bookstore.bookstoremanagement.service.Order_itemsService;

@CrossOrigin(origins= {"http://localhost:4200"})
@RequestMapping("/Order_items")
@RestController
public class Order_itemsController
{
	@Autowired
	Order_itemsService itemService;

	@GetMapping(value="/",produces="application/json")
	 public ResponseEntity<List<Order_items>>getallitems()
	 {
		  List<Order_items> t1=itemService.getallitems();
		  if(t1.size()!=0)
			return new ResponseEntity<List<Order_items>>(t1,HttpStatus.OK);
			  return new ResponseEntity<List<Order_items>>(t1,HttpStatus.NOT_FOUND);

	 }


 

	 @PostMapping(value="/",consumes="applications/json")
	 public HttpStatus insertOrder_items(@RequestBody Order_items order) {
		 if(itemService.insertorModify(order))
			 return HttpStatus.OK;
		 return HttpStatus.NOT_MODIFIED;
	}


	 @PutMapping(value="/",consumes="applications/json")
	 public HttpStatus ModifyOrder_items(@RequestBody Order_items order) {
		 if(itemService.insertorModify(order))
			 return HttpStatus.OK;
		 return HttpStatus.NOT_MODIFIED;
	}


	 @DeleteMapping("/{customerId}")
	 public HttpStatus deleteOrder_items(@PathVariable int Id)
	 {
		 if(itemService.deleteByid(Id))
			 return HttpStatus.OK;
		 return HttpStatus.NOT_FOUND;
	 }
}