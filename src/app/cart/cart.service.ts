import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';


@Injectable({
  providedIn: 'root'
})
export class CartService {

  constructor(private httpClient:HttpClient) { }

  public getCartItems():Observable<any>{
    const options={
      "withCredentials":true
    }
    return this.httpClient.get('http://localhost:8097/bucket/all',options);

    
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



  public getTotalPrice(price:number){
    const data={
      
      "bookprice": price
    }

    const options={
      "withCredentials":true
    }
    return this.httpClient.post('http://localhost:8097/bucket/order',data,options);
  }


  public increasequantity(bucketid:number)
  {
    const url="http://localhost:8097/bucket/increasequantity";

    const options={
      "withCredentials":true
    }

    const data={
      "bucketId":bucketid
    }
    window.location.reload()
    return this.httpClient.post(url,data,options);
  }
  public decreasequantity(bucketid:number)
  {
    const url="http://localhost:8097/bucket/decreasequantity";

    const options={
      "withCredentials":true
    }

    const data={
      "bucketId":bucketid
    }
    window.location.reload()

    return this.httpClient.post(url,data,options);
  }
}

