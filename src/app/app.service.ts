import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/internal/Observable';

@Injectable()

export class AppService {

  constructor(private httpClient:HttpClient) {}

  public onLoginService(txt1:string,txt2:string):Observable<any>{

    const url='http://localhost:8097/customer/login';

    const data = {

      "emailId": txt1,
      "password": txt2

    };

    const options={
      "withCredentials":true
    }
    return this.httpClient.post(url,data,options);

  }
  




}
