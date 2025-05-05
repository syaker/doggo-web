import { Component } from '@angular/core';
import { NavBarComponent } from '../NavBar/nav-bar';

@Component({
  standalone: true,
  selector: 'basic-layout',
  templateUrl: 'basic-layout.html',
  styleUrl: 'basic-layout.css',
  imports: [NavBarComponent],
})
export class BasicLayout {}
