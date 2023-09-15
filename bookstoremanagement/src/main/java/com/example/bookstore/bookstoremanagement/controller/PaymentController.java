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

import com.example.bookstore.bookstoremanagement.entity.Payments;
import com.example.bookstore.bookstoremanagement.service.PaymentsService;


@CrossOrigin(origins = {"http://localhost:4200"},allowCredentials = "true")
@RestController
@RequestMapping("/payment")
public class PaymentController {
	@Autowired
	private PaymentsService paymentService;
	
	@GetMapping
	public ResponseEntity<List<Payments>> getAllPayments()
	{
		List<Payments> blist = paymentService.getallPayments();
		if(blist.size() != 0)
			return new ResponseEntity<List<Payments>>(blist,HttpStatus.OK);
		return new ResponseEntity<List<Payments>>(blist,HttpStatus.NOT_FOUND);
	}
	

//	@GetMapping("/{trainId}")
	@GetMapping(value="/{paymentId}", produces="application/json")
	public ResponseEntity<Payments> getTrainByTrainId(@PathVariable int paymentId)
	{
		Payments a = paymentService.getPaymentbyId(paymentId);
		if(a!=null)
			return new ResponseEntity<Payments>(a, HttpStatus.OK);
		return new ResponseEntity<Payments>(a,HttpStatus.NOT_FOUND);
	}
	
	@PostMapping(value="/", consumes="application/json")
	public HttpStatus insertPayment(@RequestBody Payments payment)
	{
		paymentService.insertorModify(payment);
		return HttpStatus.OK;
	}
	
	@PutMapping(value="/", consumes="application/json")
	public HttpStatus modifyPayment(@RequestBody Payments payment)
	{
		paymentService.insertorModify(payment);
		return HttpStatus.OK;
	}
	
	@DeleteMapping("/{paymentId}")
	public HttpStatus deletepayment(@PathVariable int paymentId)
	{
		if(paymentService.deletepayment(paymentId))
			return HttpStatus.OK;
		return HttpStatus.NOT_FOUND;
	}

	
}