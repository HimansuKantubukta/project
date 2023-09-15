import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AnimatedComponent } from './animated/animated.component';
import { CartComponent } from './cart/cart.component';
import { CategoryComponent } from './category/category.component';
import { ComicComponent } from './comic/comic.component';
import { EpicComponent } from './epic/epic.component';
import { HeaderComponent } from './header/header.component';
import { HomeComponent } from './home/home.component';
import { HorrorComponent } from './horror/horror.component';
import { ItemsComponent } from './items/items.component';
import { LoginComponent } from './login/login.component';
import { LogoutComponent } from './logout/logout.component';
import { SearchComponent } from './search/search.component';
import { ThrillerComponent } from './thriller/thriller.component';
import { SliderComponent } from './slider/slider.component';
import { HttpClientModule } from '@angular/common/http';
import { AppService } from './app.service';
import { FormsModule } from '@angular/forms';
import { RegistrationComponent } from './registration/registration.component';
import { RegistrationService } from './registration/registration.service';
import { ItemsService } from './items/items.service';
import { AdminComponent } from './admin/admin.component';



@NgModule({
  declarations: [
    AppComponent,
    AnimatedComponent,
    CartComponent,
    CategoryComponent,
    ComicComponent,
    EpicComponent,
    HeaderComponent,
    HomeComponent,
    HorrorComponent,
    ItemsComponent,
    LoginComponent,
    LogoutComponent,
    SearchComponent,
    ThrillerComponent,
    SliderComponent,
   RegistrationComponent,
   AdminComponent,
   
 
   
   
   
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
  ],
  providers: [AppService,RegistrationService,ItemsService],
  bootstrap: [AppComponent]
})
export class AppModule { }
