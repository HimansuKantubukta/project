package com.example.bookstore.bookstoremanagement.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.bookstore.bookstoremanagement.entity.admins;
import com.example.bookstore.bookstoremanagement.repository.adminsRepository;
import com.example.bookstore.bookstoremanagement.service.AdminService;

import jakarta.servlet.http.HttpSession;

@CrossOrigin(origins = {"http://localhost:4200"},allowCredentials="true")
	@RequestMapping("/admin")
    @RestController
	public class AdminController {
		
	    @Autowired
		private AdminService adminService;
	    
	    @Autowired
	    adminsRepository adminrepo;
		
		@GetMapping(value="/all",produces="application/json")
		public ResponseEntity<List<admins>> getAllAdmins()
		{
			List<admins> blist = adminService.getAllAdmins();
			if(blist.size() != 0)
				return new ResponseEntity<List<admins>>(blist,HttpStatus.OK);
			return new ResponseEntity<List<admins>>(blist,HttpStatus.NOT_FOUND);
		}
		

//		@GetMapping("/{adminId}")
		@GetMapping(value="/{adminId}", produces="application/json")
		public ResponseEntity<admins> getAdminByAdminId(@PathVariable int adminId)
		{
			admins a = adminService.getAdminByAdminId(adminId);
			if(a!=null)
				return new ResponseEntity<admins>(a, HttpStatus.OK);
			return new ResponseEntity<admins>(a,HttpStatus.NOT_FOUND);
		}
		
		@PostMapping(value="/", consumes="application/json")
		public HttpStatus insertOrderItems(@RequestBody admins admin)
		{
			adminService.insertOrModifyAdmin(admin);
			return HttpStatus.OK;
		}
		
		
		
		
		@DeleteMapping("/{adminId}")
		public HttpStatus deleteadmin(@PathVariable int adminId)
		{
			if(adminService.deleteAdminByAdminId(adminId))
				return HttpStatus.OK;
			return HttpStatus.NOT_FOUND;
		}
		
		
		
		 
	     @PostMapping(value = "/login", consumes = "application/json")

	 	public ResponseEntity<String> login(HttpSession req, @RequestBody admins request) {

	 	    String emailId = request.getEmail();

	 	    String password = request.getPassword();

	 	  

	 	    admins ad = adminrepo.findAdminIdByEmailAndPassword(emailId, password);

	  

	 	    if (ad!=null) {

	 	     

	 	    	//HttpSession session = req.getSession();

	 	    	req.setAttribute("AdminId",ad.getAdminId());

	 	    	System.out.println("inside" + ad.getAdminId());

	  

	 	        return ResponseEntity.ok().build();

	 	    } else {

	 	        return ResponseEntity.notFound().build();

	 	    }
	}

	}

