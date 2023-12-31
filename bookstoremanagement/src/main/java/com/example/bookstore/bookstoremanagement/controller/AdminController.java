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
import com.example.bookstore.bookstoremanagement.entity.admins;
import com.example.bookstore.bookstoremanagement.service.AdminService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

// Enable Cross-Origin Resource Sharing (CORS) for this controller.
@CrossOrigin(origins = {"http://localhost:4200"})
@RestController
@RequestMapping("/admin")
public class AdminController {
    // Inject the AdminService using Spring's @Autowired annotation.
    @Autowired
    private AdminService adminService;
    
    // Get all admin records.
    @GetMapping
    public ResponseEntity<List<admins>> getAllAdmins() {
        List<admins> blist = adminService.getAllAdmins();
        if (blist.size() != 0)
            return new ResponseEntity<List<admins>>(blist, HttpStatus.OK);
        return new ResponseEntity<List<admins>>(blist, HttpStatus.NOT_FOUND);
    }

    // Get an admin by adminId.
    @GetMapping(value = "/{adminId}", produces = "application/json")
    public ResponseEntity<admins> getTrainByTrainId(@PathVariable int adminId) {
        admins a = adminService.getAdminByAdminId(adminId);
        if (a != null)
            return new ResponseEntity<admins>(a, HttpStatus.OK);
        return new ResponseEntity<admins>(a, HttpStatus.NOT_FOUND);
    }

    // Insert or modify an admin record.
    @PostMapping(value = "/", consumes = "application/json")
    public HttpStatus insertOrderItems(@RequestBody admins admin) {
        adminService.insertOrModifyAdmin(admin);
        return HttpStatus.OK;
    }

    // Modify an admin record.
    @PutMapping(value = "/", consumes = "application/json")
    public HttpStatus modifyAdmin(@RequestBody admins admin) {
        adminService.insertOrModifyAdmin(admin);
        return HttpStatus.OK;
    }

    // Delete an admin by adminId.
    @DeleteMapping("/{adminId}")
    public HttpStatus deleteadmin(@PathVariable int adminId) {
        if (adminService.deleteAdminByAdminId(adminId))
            return HttpStatus.OK;
        return HttpStatus.NOT_FOUND;
    }

    // Count the number of valid admins based on email and password.
    @PostMapping(value = "/login", consumes = "application/json")
    public boolean countOfValidAdmin(@RequestBody admins admin, HttpServletRequest request) {
        Integer id = adminService.countOfAdmin(admin.getEmail(), admin.getPassword());
        if (id != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("id", id);
            System.out.println(session.getAttribute("id"));
        }
        return id != null;
    }

    // Insert a new admin record.
    @PostMapping(value = "/signup", consumes = "application/json")
    public HttpStatus insertAdmin(@RequestBody admins admin) {
        adminService.insertOrModifyAdmin(admin);
        return HttpStatus.OK;
    }
}
