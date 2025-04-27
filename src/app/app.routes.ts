import { Routes } from '@angular/router';
<<<<<<< Updated upstream

export const routes: Routes = [];
=======
import { Chat } from './pages/chat/chat';
import { IncomesComponent } from './pages/incomes/incomes.component';
import { Login } from './pages/login/login';
import { NotificationsComponent } from './pages/notifications/notifications.component';
import { PetSitterProfile } from './pages/pet-sitter-profile/pet-sitter-profile';
import { RatesComponent } from './pages/rates/rates.component';
import { SignUp } from './pages/sign-up/sign-up.component';

export const routes: Routes = [
  { path: 'login', component: Login },
  { path: 'signup', component: SignUp },
  { path: 'pet-sitters', component: SignUp },
  { path: 'payments', component: SignUp },
  { path: 'pet-sitters/:petSitterId', component: PetSitterProfile },
  { path: 'chat', component: Chat },
  { path: 'incomes', component: IncomesComponent },
  { path: 'rates', component: RatesComponent },
  { path: 'notifications', component: NotificationsComponent },
  { path: '', redirectTo: 'login', pathMatch: 'full' },
];
>>>>>>> Stashed changes
