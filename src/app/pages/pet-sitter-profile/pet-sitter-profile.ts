import { Component } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'pet-sitter-profile',
  templateUrl: 'pet-sitter-profile.html',
  styleUrl: 'pet-sitter-profile.css',
  imports: [BasicLayout],
})
export class PetSitterProfile {}
