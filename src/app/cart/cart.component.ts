import { Component } from '@angular/core';
import { CartService } from './cart.service';
import { Data, Router } from '@angular/router';

@Component({
  selector: 'cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.css']
})
export class CartComponent
{
  cart:any[]=[];
  bookprice1:number=0;
  totalprice:number=0;
  constructor(private cartService : CartService,private router:Router){}

  ngOnInit():void
  {
    this.cartService.getCartItems().subscribe((data)=>{
      this.cart=data;
      this.getTotalPrice();
    });


    
  

  }
  getTotalPrice() {
    let totalPrice = 0;
    
    for (const item of this.cart) {
   
      this.bookprice1=item.quantity*item.bookprice;
      this.totalprice += this.bookprice1;
      
      console.log(item.quantity*item.bookprice);
      

      
    }
    return totalPrice ;
  }

  incraesequantity(bucketid:number)
  {
    this.cartService.increasequantity(bucketid).subscribe(
      (response)=>

      {
        console.log("book increased successfully",response);
      },
      (error)=>
      {
        console.log("book not increased,error",error);
      }
    )
    // window.location.reload();
  }

  decraesequantity(bucketid:number)
  {
    this.cartService.decreasequantity(bucketid).subscribe(
      (response)=>

      {
        console.log("book decreased successfully",response);
      },
      (error)=>
      {
        console.log("book not decreased,error",error);
      }
    )
    // window.location.reload();
  }
  
}


 
  
  





// addToCart(bookId:number,price:number){
//   this.itemsService.addToCart(bookId,price).subscribe(
//     (response)=>
//     {
//       if(response)
//       {
//         alert("added to cart");
//       }
//       else{
//         alert("not added to cart");
//       }
//     }
//   )
// }


