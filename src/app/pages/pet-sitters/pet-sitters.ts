import { CommonModule, NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'pet-sitters',
  templateUrl: 'pet-sitters.html',
  styleUrl: 'pet-sitters.css',
  imports: [BasicLayout, NgFor, CommonModule, RouterLink],
})
export class PetSitters {
  defaultSitterImage = 'assets/profile.png';
  sitters = [
    {
      id: 1,
      imageUrl: 'assets/pexels-danyochoa-3209221.jpg',
      name: 'Juana Molina',
      yearsOfExperience: 2,
      averageRating: 4,
      specialties: [''],
    },
    {
      id: 2,
      imageUrl: 'assets/pexels-hannah-nelson-390257-1065084.jpg',
      name: 'Maria Perez',
      yearsOfExperience: 2,
      averageRating: 1,
      specialties: [''],
    },
    {
      id: 3,
      imageUrl: 'assets/pexels-javier-captures-the-world-297237582-19003848.jpg',
      name: 'Naruto Uzumaki',
      yearsOfExperience: 2,
      averageRating: 4,
      specialties: [''],
    },
    {
      id: 4,
      imageUrl: 'assets/pexels-olly-733872.jpg',
      name: 'Mercedes Escalante',
      yearsOfExperience: 2,
      averageRating: 4,
      specialties: [''],
    },
    {
      id: 5,
      imageUrl: 'profile.png',
      name: 'John Doe',
      yearsOfExperience: 2,
      averageRating: 4,
      specialties: [''],
    },
  ];
  open = false;

  handleModal(sitter: {
    id: number;
    imageUrl: string;
    name: string;
    yearsOfExperience: number;
    averageRating: number;
    specialties: string[];
  }) {
    this.open = !this.open;
  }
}
