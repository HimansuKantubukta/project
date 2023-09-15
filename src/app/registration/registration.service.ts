import { Injectable } from "@angular/core";
import { HttpHeaders } from "@angular/common/http";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { BigNumber } from 'bignumber.js';


@Injectable()



export class RegistrationService{

    constructor (private httpclient:HttpClient){};

     onsubmitService(txt1: string,txt2:string , txt3: string, txt5: number, txt6: string,txt7: string):Observable<any>
    {
      const phone = BigNumber(txt2);
      console.log(phone);
      console.log(txt5)
       
      const url='http://localhost:8097/customer/register';
      const data={
         "customerName": txt1,
          "email_id": txt3,
          "mobile": phone,
          "postalCode": txt5,
          "stateName": txt6,
          "password": txt7
          
    
      }
    
      console.log(data);
      const optional={
        Headers:new HttpHeaders({'content-Type':'application/json'}),
        responseType:'text' as 'json'
      };

      return this.httpclient.post(url,data,optional);
      
    }
    

}