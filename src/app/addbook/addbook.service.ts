import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AddbookService{

constructor (private httpclient:HttpClient){};

onsubmitService(txt1:number,txt2:string , txt3: string, txt5: number, txt6: number,txt7: string):Observable<any>
{
  
 const url='http://localhost:8097/book/add';
 const data={
     "book_id": txt1,
     "title": txt2,
     "category": txt3,
     "price": txt5,
     "authorId":{
      "author_id":txt6
     } ,
     "link": txt7
     

 }

 console.log(data);
 const optional={
   Headers:new HttpHeaders({'content-Type':'application/json'}),
   responseType:'text' as 'json'
 };

 return this.httpclient.post(url,data,optional);
 
}


}
