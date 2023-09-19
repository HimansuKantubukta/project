package com.example.bookstore.bookstoremanagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="inventory")
public class Inventory 
{
	@Id
	@Column(name="Inventory_id")
	private int inv_id;
	
	@Column(name="Book_id")
	private int book_id;
	
	@Column(name="stock_level_used")
	private int stock_level_used;
	
	@Column(name="stock_level_new")
	private int stock_level_new;

	public Inventory() {
		super();
	}

	public Inventory(int inv_id, int book_id, int stock_level_used, int stock_level_new) {
		super();
		this.inv_id = inv_id;
		this.book_id = book_id;
		this.stock_level_used = stock_level_used;
		this.stock_level_new = stock_level_new;
	}

	public int getInv_id() {
		return inv_id;
	}

	public void setInv_id(int inv_id) {
		this.inv_id = inv_id;
	}

	public int getBook_id() {
		return book_id;
	}

	public void setBook_id(int book_id) {
		this.book_id = book_id;
	}

	public int getStock_level_used() {
		return stock_level_used;
	}

	public void setStock_level_used(int stock_level_used) {
		this.stock_level_used = stock_level_used;
	}

	public int getStock_level_new() {
		return stock_level_new;
	}

	public void setStock_level_new(int stock_level_new) {
		this.stock_level_new = stock_level_new;
	}
	
	

}
