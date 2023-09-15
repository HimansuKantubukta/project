import { Component } from '@angular/core';
import { SearchService } from '../services/search.service';
import { NgForm } from '@angular/forms';

@Component({
  selector: 'search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent
 {

  constructor(private searchService:SearchService) {}

  response :any;
  value : string = '';
  public searchBook() {
    this.searchService.searchBook(this.value).subscribe((res)=>{console.log(res);
      this.response = res;
    }); 
    console.log(this.value);
    
  }

}
