import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ItemsService } from './items.service';
@Component({
  selector: 'items',
  templateUrl: './items.component.html',
  styleUrls: ['./items.component.css']
})
export class ItemsComponent implements OnInit

{

  books:any[]=[];

  constructor(private itemsService : ItemsService,private router:Router){}

  ngOnInit(): void

    {
        this.itemsService.getAllItemDetails('').subscribe((data)=> this.books = data);

        console.log(this.books)

    }

    showBooksByTitle(title:string){

      const url='/search/'+title;

      this.itemsService.getAllItemDetails(url).subscribe((data)=> this.books = data);

    }

    addToCart(bookId:number,price:number){
      this.itemsService.addToCart(bookId,price).subscribe(
        (response)=>
        {
          if(response)
          {
            alert("added to cart");
          }
          else{
            alert("not added to cart");
          }
        }
      )
    }
  

}
