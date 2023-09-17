import { Component } from '@angular/core';
import { AddbookService } from './addbook.service';

@Component({
  selector: 'addbook',
  templateUrl: './addbook.component.html',
  styleUrls: ['./addbook.component.css']
})
export class AddbookComponent 
{
  constructor(private add:AddbookService){}



  onsubmit(txt1: string, txt2: string, txt3: string, txt5: string, txt6: string, txt7: string) {
    // const numericValue = parseInt(txt5);
    // const firstValue = parseInt(txt1);
    // const sixthvalue =parseInt(txt6);

  
   
    this.add.onsubmitService(Number(txt1),txt2,txt3,Number(txt5),Number(txt6),txt7).subscribe(
      (response) =>
      {
        console.log("Successfull");
          alert("Book Added successfull")
      },
      (error)=>
      {
          console.log("Not happening")

      }
      
    )
  
   
  
  }
  

}
