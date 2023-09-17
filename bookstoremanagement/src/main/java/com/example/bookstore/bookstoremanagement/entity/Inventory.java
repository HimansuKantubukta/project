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
	private int invId;
	
	@Column(name="Book_id")
	private int bookId;
	
	@Column(name="stock_level_used")
	private int stockLevelUsed;
	
	@Column(name="stock_level_new")
	private int stockLevelNew;

	public Inventory() {
		super();
	}

	public Inventory(int inv_id, int book_id, int stock_level_used, int stock_level_new) {
		super();
		this.invId = inv_id;
		this.bookId = book_id;
		this.stockLevelUsed = stock_level_used;
		this.stockLevelNew = stock_level_new;
	}

	public int getInv_id() {
		return invId;
	}

	public void setInv_id(int inv_id) {
		this.invId = inv_id;
	}

	public int getBook_id() {
		return bookId;
	}

	public void setBook_id(int book_id) {
		this.bookId = book_id;
	}

	public int getStock_level_used() {
		return stockLevelUsed;
	}

	public void setStock_level_used(int stock_level_used) {
		this.stockLevelUsed = stock_level_used;
	}

	public int getStock_level_new() {
		return stockLevelNew;
	}

	public void setStock_level_new(int stock_level_new) {
		this.stockLevelNew = stock_level_new;
	}
	
	

}
