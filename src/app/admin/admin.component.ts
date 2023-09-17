import { Component } from '@angular/core';
import { AppService } from '../app.service';
import { Router } from '@angular/router';
import { AdminloginService } from '../adminlogin.service';

@Component({
  selector: 'admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.css']
})
export class AdminComponent
 {


  
  constructor(private adminloginservice:AdminloginService,private router:Router) {}

  onAdminLogin(txt1: string, txt2: string){
   
      this.adminloginservice.onAdminLoginService(txt1, txt2).subscribe((response)=>{
        
          console.log("Successfull");
            alert("login successfull")
      
  
        this.router.navigate(['adminhome']);
  
      },
  
      (error)=>{
  
        console.log("invalid login credentials");
        alert("invalid login credentials");
  
      })
  
    }
  
   

}

