// This is the package declaration for the service class.
package com.example.bookstore.bookstoremanagement.service;

// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.CustomersRepository;

// Define the CustomersService class as a service.
@Service
public class CustomersService {

    // Inject the CustomersRepository using Spring's @Autowired annotation.
    @Autowired
    CustomersRepository customersRepository;

    // Read-only transactional method to get all customer records.
    @Transactional(readOnly=true)
    public List<Customers> getAllCustomers() {
        return customersRepository.findAll();
    }

    // Read-only transactional method to get a customer by cust_id.
    @Transactional(readOnly=true)
    public Customers getcustomersById(int cust_id) {
        Optional<Customers> ct = customersRepository.findById(cust_id);
        if (ct.isPresent())
            return ct.get();
        return null;
    }

    // Transactional method to insert a new customer into the database.
    @Transactional
    public boolean insertIntoCustomers(Customers cust) {
        return customersRepository.save(cust) != null;
    }

    // Transactional method to delete a customer by cust_id.
    @Transactional
    public boolean deletBycustomerId(int cust_id) {
        long count = customersRepository.count();
        customersRepository.deleteById(cust_id);
        return count > customersRepository.count();
    }

    // The following section is commented out. You can uncomment it and add the appropriate query logic if needed.
    
    // Transactional method to count the number of customers based on email and password.
//    @Transactional
//    public Integer countOfCustomer(String email, String password) {
//        Customers c = customersRepository.findByEmailIdAndPassword(email, password);
//        if (c != null) {
//            return c.getCustomer_id();
//        } else
//            return null;
//    }
}
