// This is the package declaration for the entity class.
package com.example.bookstore.bookstoremanagement.entity;

// Import necessary annotations from the Jakarta Persistence API.
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

// Define the entity class named "Inventory."
@Entity
@Table(name="inventory")
public class Inventory 
{
    // Declare the primary key field for Inventory, annotated with @Id.
    @Id
    @Column(name="Inventory_id")
    private int inv_id;
    
    // Declare a field for the book ID.
    @Column(name="Book_id")
    private int book_id;
    
    // Declare a field for the used stock level.
    @Column(name="stock_level_used")
    private int stock_level_used;
    
    // Declare a field for the new stock level.
    @Column(name="stock_level_new")
    private int stock_level_new;

    // Default constructor for Inventory.
    public Inventory() {
        super();
    }

    // Parameterized constructor for Inventory.
    public Inventory(int inv_id, int book_id, int stock_level_used, int stock_level_new) {
        super();
        this.inv_id = inv_id;
        this.book_id = book_id;
        this.stock_level_used = stock_level_used;
        this.stock_level_new = stock_level_new;
    }

    // Getter method for inv_id.
    public int getInv_id() {
        return inv_id;
    }

    // Setter method for inv_id.
    public void setInv_id(int inv_id) {
        this.inv_id = inv_id;
    }

    // Getter method for book_id.
    public int getBook_id() {
        return book_id;
    }

    // Setter method for book_id.
    public void setBook_id(int book_id) {
        this.book_id = book_id;
    }

    // Getter method for stock_level_used.
    public int getStock_level_used() {
        return stock_level_used;
    }

    // Setter method for stock_level_used.
    public void setStock_level_used(int stock_level_used) {
        this.stock_level_used = stock_level_used;
    }

    // Getter method for stock_level_new.
    public int getStock_level_new() {
        return stock_level_new;
    }

    // Setter method for stock_level_new.
    public void setStock_level_new(int stock_level_new) {
        this.stock_level_new = stock_level_new;
    }
}
