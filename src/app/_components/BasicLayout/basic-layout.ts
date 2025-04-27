import { Component } from '@angular/core';
import { NavBar } from '../NavBar/navbar';

@Component({
  standalone: true,
  selector: 'basic-layout',
  templateUrl: 'basic-layout.html',
  styleUrl: 'basic-layout.css',
  imports: [NavBar],
})
export class BasicLayout {}
