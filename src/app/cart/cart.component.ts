import { Component } from '@angular/core';
import { CartService } from './cart.service';
import { Router } from '@angular/router';

@Component({
  selector: 'cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.css']
})
export class CartComponent
{
  cart:any[]=[];
  constructor(private cartService : CartService,private router:Router){}

  ngOnInit():void
  {
    this.cartService.getCartItems().subscribe((data)=>{
      this.cart=data;
      // console.log(data);
    });

  }
  


}
