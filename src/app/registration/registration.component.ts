import { Component } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import { RegistrationService } from './registration.service';



@Component({
  selector: 'registration',
  templateUrl: './registration.component.html',
  styleUrls: ['./registration.component.css']
})
export class RegistrationComponent
{
  constructor(private resgse:RegistrationService){}



  onsubmit(txt1: string, txt2: string, txt3: string, txt5: string, txt6: string, txt7: string) {
    const numericValue = parseInt(txt5);
  
    if (isNaN(numericValue)) {
      console.error("Invalid numeric input for txt5");
      // Handle the error gracefully, such as showing a user-friendly message.
      return;
    }

    this.resgse.onsubmitService(txt1,txt2,txt3,numericValue,txt6,txt7).subscribe(
      (response) =>
      {
        console.log("Successfull");
          alert("Registration successfull")
      },
      (error)=>
      {
          console.log("Not happening")
      }
      
    )
  
   
  
  }
  

}
