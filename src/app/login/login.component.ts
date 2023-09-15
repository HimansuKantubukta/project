import { Component } from '@angular/core';
import { AppService } from '../app.service';
import { Router } from '@angular/router';

@Component({
  selector: 'login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent 
{
  
  constructor(private appservice:AppService,private router:Router) {}

  onLogin(txt1: string, txt2: string){
   
      this.appservice.onLoginService(txt1, txt2).subscribe((response)=>{
  
        this.router.navigate(['home']);
  
      },
  
      (error)=>{
  
        console.log(error)
  
      })
  
    }
  
   

}
