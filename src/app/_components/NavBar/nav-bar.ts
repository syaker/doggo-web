import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'nav-bar',
  templateUrl: './nav-bar.html',
  styleUrls: ['./nav-bar.css'],
  imports: [RouterLink],
})
export class NavBarComponent {
  isOpen = false;

  toggleMenu(): void {
    this.isOpen = !this.isOpen;
  }
}
