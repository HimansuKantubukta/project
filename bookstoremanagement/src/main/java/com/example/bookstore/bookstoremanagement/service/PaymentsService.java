package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Payments;
import com.example.bookstore.bookstoremanagement.repository.PaymentsRepository;

@Service

public class PaymentsService {

@Autowired

PaymentsRepository  paymentrepository;

 

 

@Transactional(readOnly=true)

public List<Payments> getallPayments(){

    return paymentrepository.findAll();

}

 

 

  @Transactional(readOnly=true)

  public Payments getPaymentbyId(int id) {

    Optional<Payments> pp= paymentrepository.findById(id);

    if(pp.isPresent())

        return pp.get();

    return null;

      

  }

  @Transactional

  

  public boolean insertorModify(Payments  payment) {

    return paymentrepository.save(payment)!=null;

      

  

  }

  @Transactional

  public boolean deletepayment(int id) {

         long count=paymentrepository.count();

         paymentrepository.deleteById(id);

            return count> paymentrepository.count();

  }

}