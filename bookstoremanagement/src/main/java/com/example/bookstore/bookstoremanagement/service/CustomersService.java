package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.CustomersRepository;

@Service

public class CustomersService {

@Autowired

CustomersRepository  customersRepository;

    

    

     @Transactional(readOnly=true)

     public List<Customers> getAllCustomers(){

          return customersRepository.findAll();

     

     }

     @Transactional(readOnly=true)

     public Customers getcustomersById(int cust_id) {

    Optional<Customers> ct= customersRepository.findById(cust_id);

    if(ct.isPresent())

        return ct.get();

    return null;

     }

     

      @Transactional

      public boolean insertIntoCustomers(Customers cust) {

        return customersRepository.save(cust)!=null;

          

      }

      

    @Transactional

    public boolean deletBycustomerId(int cust_id) {

         long count=customersRepository.count();

         customersRepository.deleteById(cust_id);

            return count> customersRepository.count();

    }
   
//    @Transactional
//
//    public Integer countOfCustomer(String email,String password) {
//		Customers c = customersRepository.findByEmailIdAndPassword(email, password);
//		if(c != null) {
//			return c.getCustomer_id();
//		}
//		else
//			return null;
//	}

}