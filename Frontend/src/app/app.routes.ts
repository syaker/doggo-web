import { Routes } from '@angular/router';
import { Chat } from './pages/chat/chat';
import { Fees } from './pages/fees/fees';
import { Home } from './pages/home/home';
import { Login } from './pages/login/login';
import { PetSitters } from './pages/pet-sitters/pet-sitters';
import { Register } from './pages/register/register';
import { Schedule } from './pages/schedule/schedule';

export const routes: Routes = [
  { path: 'login', component: Login },
  { path: 'register', component: Register },
  { path: 'home', component: Home },
  { path: 'pet-sitters', component: PetSitters },
  { path: 'chat/:sitterId', component: Chat },
  { path: 'fees', component: Fees },
  { path: 'schedule/:sitterId', component: Schedule },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
];
