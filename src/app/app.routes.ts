import { Routes } from '@angular/router';
import { Chat } from './pages/chat/chat';
import { Fees } from './pages/fees/fees';
import { Home } from './pages/home/home';
import { Login } from './pages/login/login';
import { PetSitters } from './pages/pet-sitters/pet-sitters';
import { Schedule } from './pages/schedule/schedule';

export const routes: Routes = [
  { path: 'login', component: Login },
  { path: 'home', component: Home },
  { path: 'pet-sitters', component: PetSitters },
  { path: 'chat', component: Chat },
  { path: 'fees', component: Fees },
  { path: 'schedule', component: Schedule },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
];
