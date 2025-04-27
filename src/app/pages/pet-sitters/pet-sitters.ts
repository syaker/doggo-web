import { Component } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'pet-sitters',
  templateUrl: 'pet-sitters.html',
  styleUrl: 'pet-sitters.css',
  imports: [BasicLayout],
})
export class PetSitters {}
