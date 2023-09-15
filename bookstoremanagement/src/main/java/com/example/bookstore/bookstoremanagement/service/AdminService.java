package com.example.bookstore.bookstoremanagement.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.bookstore.bookstoremanagement.entity.admins;
import com.example.bookstore.bookstoremanagement.repository.adminsRepository;

@Service
public class AdminService {
	@Autowired
	private adminsRepository adminRepo;

	@Transactional(readOnly=true)
	public List<admins> getAllAdmins()
	{
		return adminRepo.findAll();
	}
	
	@Transactional(readOnly=true)
	public admins getAdminByAdminId(int adminId)
	{
		Optional<admins> ot = adminRepo.findById(adminId);
		if(ot.isPresent())
			return ot.get();
		return new admins();
	}
	
	@Transactional
	public boolean insertOrModifyAdmin(admins admin)
	{
		if(adminRepo.save(admin) == null)
			return false;
			return true;
	}
	
	@Transactional
	public boolean deleteAdminByAdminId(int adminId)
	{
		long count = adminRepo.count();
		adminRepo.deleteById(adminId);
		if(count > adminRepo.count())
			return true;
		return false;
	}
	
	@Transactional
	public Integer countOfAdmin(String email,String password) {
		admins a = adminRepo.findAdminIdByEmailAndPassword(email, password);
		if(a != null) {
			return a.getAdminId();
		}
		else
			return null;
	}
}