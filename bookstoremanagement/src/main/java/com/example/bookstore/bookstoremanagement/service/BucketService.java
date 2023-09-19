package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.Bucket;
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.BucketRepository;

@Service
public class BucketService {
@Autowired
BucketRepository bucketRepository;


@Transactional(readOnly=true)
public List<Bucket> getalldetails(){
    return  bucketRepository.findAll();

}

//@Transactional(readOnly=true)
//public List<Bucket> getBooksByCustomrId(Customers customer)
//{
//	return bucketRepository.findByCustomer_id(customer);
//}
@Transactional(readOnly=true)
public Bucket getbucketByid( int id) {
    Optional<Bucket> bt= bucketRepository.findById(id);
    if(bt.isPresent())
        return bt.get();
        return null;   }
@Transactional
public boolean insertorModify(Bucket bucket) {
    return  bucketRepository.save(bucket)!=null;

}
@Transactional
  public boolean deleteByid(int id) {
     long count=bucketRepository.count();
     bucketRepository.deleteById(id);
    return count> bucketRepository.count();
}
}