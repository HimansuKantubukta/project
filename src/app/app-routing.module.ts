import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { SearchComponent } from './search/search.component';
import { CartComponent } from './cart/cart.component';
import { LogoutComponent } from './logout/logout.component';
import { CategoryComponent } from './category/category.component';
import { ItemsComponent } from './items/items.component';
import { EpicComponent } from './epic/epic.component';
import { ComicComponent } from './comic/comic.component';
import { HorrorComponent } from './horror/horror.component';
import { ThrillerComponent } from './thriller/thriller.component';
import { LoginComponent } from './login/login.component';
import { RegistrationComponent } from './registration/registration.component';
import { AdminComponent } from './admin/admin.component';
import { AnimatedComponent } from './animated/animated.component';
import { NewnavComponent } from './newnav/newnav.component';
import { AdminhomeComponent } from './adminhome/adminhome.component';
import { AddbookComponent } from './addbook/addbook.component';


const routes: Routes = [

  {
    path:"home",component:HomeComponent
  },
  {
    path:"newnav",component:NewnavComponent
  },
  {
    path:"addbook",component:AddbookComponent
  },
  {
    path:"adminhome",component:AdminhomeComponent

  },
  {
    path:"animated",component:AnimatedComponent
  },


  {
    path:"search",component:SearchComponent

  },
  {
    path:"category",component:CategoryComponent

  },
  {
    path:"admin",component:AdminComponent
  },

  {
    path:"cart",component:CartComponent
  },
  {
    path:"logout",component:LogoutComponent
  },
  {
    path:"items",component:ItemsComponent
  },
  {
    path:"epic",component:EpicComponent
  },
  
  {
    path:"comic",component:ComicComponent
  },
  {
    path:"horror",component:HorrorComponent
  },
  {
    path:"thriller",component:ThrillerComponent
  },
  {
    path:"",component:LoginComponent
  },
  {
    path:"registration",component:RegistrationComponent
  }
  

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
