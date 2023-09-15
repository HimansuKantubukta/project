import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';

@Injectable({
  providedIn: 'root'
})
export class ItemsService {

  constructor(private httpClient: HttpClient) { }

  public getAllItemDetails(con: string): Observable<any> {

    const options={
      "withCredentials":true
    }
    return this.httpClient.get('http://localhost:8097/book/all' + con,options);

  }

  public addToCart(bookId:number,price:number){
    const data={
      "book_id": {
        "book_id": bookId
      },
      "bookprice": price
    }

    const options={
      "withCredentials":true
    }
    return this.httpClient.post('http://localhost:8097/bucket/order',data,options);
  }
}
