package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Order_items;
import com.example.bookstore.bookstoremanagement.repository.Order_itemsRepository;

@Service

public class Order_itemsService {

@Autowired

Order_itemsRepository order_itemsrepository;

@Transactional

public List<Order_items> getallitems(){

    return order_itemsrepository.findAll();

}


@Transactional(readOnly=true)

  public Order_items getByid(int order_id) {

    Optional<Order_items> ot=order_itemsrepository.findById(order_id);

    if(ot.isPresent())

        return ot.get();

    return null;

}

@Transactional

public boolean insertorModify(Order_items order) {

    return order_itemsrepository.save(order)!=null;


}

@Transactional

public boolean  deleteByid(int id) {

     long count=order_itemsrepository.count();

     order_itemsrepository.deleteById(id);

    return count> order_itemsrepository.count();

}

 

}
