import { Routes } from '@angular/router';
import { Chat } from './pages/chat/chat';
import { Login } from './pages/login/login';
import { PetSitterProfile } from './pages/pet-sitter-profile/pet-sitter-profile';
import { SignUp } from './pages/sign-up/sign-up.component';

export const routes: Routes = [
  { path: 'login', component: Login },
  { path: 'signup', component: SignUp },
  { path: 'pet-sitters', component: SignUp },
  { path: 'payments', component: SignUp },
  { path: 'pet-sitters/:petSitterId', component: PetSitterProfile },
  { path: 'chat', component: Chat },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
];
