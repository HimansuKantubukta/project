package com.example.bookstore.bookstoremanagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;

@Entity
@Table(name="customers")
public class Customers {
	@Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)

 

    @Column(name="cust_id")
    private int customer_id;
    @Column(name="cust_name")
    private String customerName;
    @Column(name="cust_mobile")
    private long mobile;
    @Column(name="email_id")
    private String emailId;
   
    @Column(name="postal_code")
    private int postalCode;
    @Column(name="state")
    private String stateName;
    @Column(name="password")
    private String password;
//    @Column(name="country")
//    private String countryName;
    @Column(name="createdat")
    private LocalDate date;



    public Customers() {}





	public Customers(int customer_id, String customerName, long mobile, String emailId,
			int postalCode, String stateName, String password,LocalDate date) {
		super();
		this.customer_id = customer_id;
		this.customerName = customerName;
		this.mobile = mobile;
		this.emailId = emailId;
		this.postalCode = postalCode;
		this.stateName = stateName;
		this.password = password;
		this.date=date;
		//this.countryName = countryName;
	}
	
	public int getCustomer_id() {
		return customer_id;
	}





	public void setCustomer_id(int customer_id) {
		this.customer_id = customer_id;
	}





	public String getCustomerName() {
		return customerName;
	}





	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}





	public long getMobile() {
		return mobile;
	}





	public void setMobile(long mobile) {
		this.mobile = mobile;
	}





	public String getEmailId() {
		return emailId;
	}





	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}






	public int getPostalCode() {
		return postalCode;
	}





	public void setPostalCode(int postalCode) {
		this.postalCode = postalCode;
	}





	public String getStateName() {
		return stateName;
	}





	public void setStateName(String stateName) {
		this.stateName = stateName;
	}





	public String getPassword() {
		return password;
	}





	public void setPassword(String password) {
		this.password = password;
	}


	


//	public String getCountryName() {
//		return countryName;
//	}
//
//
//
//
//
//	public void setCountryName(String countryName) {
//		this.countryName = countryName;
//	}

	public LocalDate getDate() {
		return date;
	}

	public void setDate(LocalDate date) {
		this.date = date;
	}


}
