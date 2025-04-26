import { Routes } from '@angular/router';
import { PetsitterprofileComponent } from './pages/petsitterprofile/petsitterprofile.component';
import { PetsitterfeeComponent } from './pages/petsitterfee/petsitterfee.component';
import { PetsitterchatComponent } from './pages/petsitterchat/petsitterchat.component';

export const routes: Routes = [
    { path: 'petsitterprofile', component: PetsitterprofileComponent },
    { path: 'petsitterchat', component: PetsitterchatComponent },
    { path: 'petsitterfee', component: PetsitterfeeComponent }
];

