import { Component } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'home',
  templateUrl: 'home.html',
  styleUrl: 'home.css',
  imports: [BasicLayout],
})
export class Home {
  categories: string[] = [];
  services: string[] = [];

  constructor() {
    this.loadCategories();
  }

  loadCategories() {
    this.categories = ['Box 1', 'Box 2', 'Box 3', 'Box 4'];
    this.services = ['Box 1', 'Box 2', 'Box 3', 'Box 4'];
  }
}
