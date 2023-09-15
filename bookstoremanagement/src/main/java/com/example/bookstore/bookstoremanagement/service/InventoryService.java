package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Inventory;
import com.example.bookstore.bookstoremanagement.repository.InventoryRepository;


@Service
public class InventoryService
{
	@Autowired
	InventoryRepository inventoryrepository;
	
	@Transactional(readOnly=true)

    public List<Inventory> getAllinventories(){

         return inventoryrepository.findAll();

    

    }

    @Transactional(readOnly=true)

    public Inventory getcustomersById(int cust_id)
    {

   Optional<Inventory> ct= inventoryrepository.findById(cust_id);

   if(ct.isPresent())

       return ct.get();

   return null;

    }

    

     @Transactional

     public boolean insertIntoinventory(Inventory cust) {

       return inventoryrepository.save(cust)!=null;

         

     }

     

   @Transactional

   public boolean deletBycustomerId(int cus_id) {

        long count=inventoryrepository.count();

        inventoryrepository.deleteById(cus_id);

           return count> inventoryrepository.count();

   }

}

