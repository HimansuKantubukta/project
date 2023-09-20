// This is the package declaration for the entity class.
package com.example.bookstore.bookstoremanagement.entity;

// Import necessary annotations from the Jakarta Persistence API.
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

// Define the entity class named "admins."
@Entity
public class admins {
    // Declare the primary key field for admins, annotated with @Id and generated using Identity strategy.
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="admin_id")
    private int adminId;
    
    // Declare a field for the email.
    private String email;
    
    // Declare a field for the password.
    private String password;

    // Default constructor for admins.
    public admins() {}

    // Parameterized constructor for admins.
    public admins(int adminId, String email, String password) {
        super();
        this.adminId = adminId;
        this.email = email;
        this.password = password;
    }

    // Getter method for adminId.
    public int getAdminId() {
        return adminId;
    }

    // Setter method for adminId.
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    // Getter method for email.
    public String getEmail() {
        return email;
    }

    // Setter method for email.
    public void setEmail(String email) {
        this.email = email;
    }

    // Getter method for password.
    public String getPassword() {
        return password;
    }

    // Setter method for password.
    public void setPassword(String password) {
        this.password = password;
    }
}
