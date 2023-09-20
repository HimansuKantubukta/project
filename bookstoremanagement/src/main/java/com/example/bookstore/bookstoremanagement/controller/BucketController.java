// This is the package declaration for the controller class.
package com.example.bookstore.bookstoremanagement.controller;

// Import necessary classes and annotations.
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
import com.example.bookstore.bookstoremanagement.entity.Bucket;
import com.example.bookstore.bookstoremanagement.entity.Customers;
import com.example.bookstore.bookstoremanagement.service.BucketService;
import jakarta.servlet.http.HttpSession;

// Enable Cross-Origin Resource Sharing (CORS) for this controller.
@CrossOrigin(origins = {"http://localhost:4200"}, allowCredentials = "true")
@RequestMapping("/bucket")
@RestController
public class BucketController {
    // Inject the BucketService using Spring's @Autowired annotation.
    @Autowired
    BucketService bucketService;

    // Get all details of the bucket.
    @GetMapping(value = "/", produces = "application/json")
    public ResponseEntity<List<Bucket>> getalldetails(HttpSession session) {
        if (session.getAttribute("customerId") != null) {
            List<Bucket> t1 = bucketService.getalldetails();
            if (t1.size() != 0) {
                return ResponseEntity.ok(t1);
            }
        }
        return ResponseEntity.notFound().build();
    }

    // Insert an order into the bucket.
    @PostMapping(value = "/order", consumes = "application/json")
    public HttpStatus insertCart(@RequestBody Bucket cart, HttpSession session) {
        System.out.println(session.getAttribute("customerId"));
        if (session.getAttribute("customerId") != null) {
            Customers cust = new Customers();
            cust.setCustomer_id((int) session.getAttribute("customerId"));
            cart.setCustomer_id(cust);
            cart.setBook_id(cart.getBook_id());
            cart.setQuantity(1);
            bucketService.insertorModify(cart);
            return HttpStatus.OK;
        }
        return HttpStatus.NOT_MODIFIED;
    }

    // Modify a bucket entry.
    @PutMapping(value = "/", consumes = "application/json")
    public HttpStatus ModifyBucket(@RequestBody Bucket bucket) {
        if (bucketService.insertorModify(bucket))
            return HttpStatus.OK;
        return HttpStatus.NOT_MODIFIED;
    }

    // Delete a bucket entry by customerId.
    @DeleteMapping("/{customerId}")
    public HttpStatus deleteBucket(@PathVariable int Id) {
        if (bucketService.deleteByid(Id))
            return HttpStatus.OK;
        return HttpStatus.NOT_FOUND;
    }
}
