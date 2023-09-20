// This is the package declaration for the controller class.
package com.example.bookstore.bookstoremanagement.controller;

// Import necessary classes and annotations.
import java.util.List;
import java.time.LocalDate;
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
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.repository.CustomersRepository;
import com.example.bookstore.bookstoremanagement.service.CustomersService;
import jakarta.servlet.http.HttpSession;

// Enable Cross-Origin Resource Sharing (CORS) for this controller.
@CrossOrigin(origins = {"http://localhost:4200"}, allowCredentials = "true")
@RequestMapping("/customer")
@RestController
public class CustomerController {

    @Autowired
    CustomersService customerService;
    
    @Autowired
    CustomersRepository customerRepo;

    // Get all customers.
    @GetMapping(value = "/all", produces = "application/json")
    public ResponseEntity<List<Customers>> getAllCustomers() {
        List<Customers> t1 = customerService.getAllCustomers();

        if (t1.size() != 0)
            return new ResponseEntity<List<Customers>>(t1, HttpStatus.OK);
        return new ResponseEntity<List<Customers>>(t1, HttpStatus.NOT_FOUND);
    }

    // Register a new customer.
    @PostMapping(value = "/register", consumes = "application/json")
    public void insertCustomer1(@RequestBody Customers cs) {
        // Call the stored procedure to insert the customer data.
        customerRepo.insertinto(cs.getCustomerName(), cs.getMobile(), cs.getEmailId(),
            cs.getPostalCode(), cs.getStateName(), cs.getPassword(), LocalDate.now());
    }

    // Modify customer details.
    @PutMapping(value = "/", consumes = "application/json")
    public HttpStatus ModifyCustomer(@RequestBody Customers customer) {
        if (customerService.insertIntoCustomers(customer))
            return HttpStatus.OK;
        return HttpStatus.NOT_MODIFIED;
    }

    // Delete a customer by customerId.
    @DeleteMapping("/{customerId}")
    public HttpStatus deleteCustomer(@PathVariable int customerId) {
        if (customerService.deletBycustomerId(customerId))
            return HttpStatus.OK;
        return HttpStatus.NOT_FOUND;
    }

    // Login a customer.
    @PostMapping(value = "/login", consumes = "application/json")
    public ResponseEntity<String> login(HttpSession req, @RequestBody Customers request) {
        String emailId = request.getEmailId();
        String password = request.getPassword();

        Customers c = customerRepo.findCustomersByEmailIdAndPassword(emailId, password);

        if (c != null) {
            // Set the customerId as an attribute in the session.
            req.setAttribute("customerId", c.getCustomer_id());
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
