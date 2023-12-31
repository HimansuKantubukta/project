// This is the package declaration for the service class.
package com.example.bookstore.bookstoremanagement.service;

// Import necessary classes and annotations.
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.bookstore.bookstoremanagement.entity.admins;
import com.example.bookstore.bookstoremanagement.repository.adminsRepository;

// Define the AdminService class as a service.
@Service
public class AdminService {
    // Inject the adminsRepository using Spring's @Autowired annotation.
    @Autowired
    private adminsRepository adminRepo;

    // Read-only transactional method to get all admin records.
    @Transactional(readOnly = true)
    public List<admins> getAllAdmins() {
        return adminRepo.findAll();
    }

    // Read-only transactional method to get an admin by adminId.
    @Transactional(readOnly = true)
    public admins getAdminByAdminId(int adminId) {
        Optional<admins> ot = adminRepo.findById(adminId);
        if (ot.isPresent())
            return ot.get();
        return new admins();
    }

    // Transactional method to insert or modify an admin.
    @Transactional
    public boolean insertOrModifyAdmin(admins admin) {
        if (adminRepo.save(admin) == null)
            return false;
        return true;
    }

    // Transactional method to delete an admin by adminId.
    @Transactional
    public boolean deleteAdminByAdminId(int adminId) {
        long count = adminRepo.count();
        adminRepo.deleteById(adminId);
        if (count > adminRepo.count())
            return true;
        return false;
    }

    // Transactional method to count the number of admins based on email and password.
    @Transactional
    public Integer countOfAdmin(String email, String password) {
        admins a = adminRepo.findAdminIdByEmailAndPassword(email, password);
        if (a != null) {
            return a.getAdminId();
        } else
            return null;
    }
}
