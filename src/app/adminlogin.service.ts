import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';

@Injectable({
  providedIn: 'root'
})


export class AdminloginService {
  constructor(private httpClient:HttpClient) {}

  public onAdminLoginService(txt1:string,txt2:string):Observable<any>{

    const url='http://localhost:8097/admin/login';

    const data = {

      "email": txt1,
      "password": txt2

    };

    const options={
      "withCredentials":true
    }
    return this.httpClient.post(url,data,options);

  }


 

}
