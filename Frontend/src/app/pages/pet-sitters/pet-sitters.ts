import { CommonModule, NgFor } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';
import { doggoClient } from '../../lib/doggo/client';

@Component({
  standalone: true,
  selector: 'pet-sitters',
  templateUrl: 'pet-sitters.html',
  styleUrls: ['pet-sitters.css'],
  imports: [BasicLayout, NgFor, CommonModule, RouterLink],
})
export class PetSitters implements OnInit {
  defaultSitterImage = 'assets/profile.png';
  sitters: Array<{
    id: number;
    name: string;
    imageUrl?: string;
    yearsOfExperience?: number;
    averageRating?: number;
    specialties?: string[];
  }> = [];

  open = false;

  async ngOnInit() {
    await this.loadSitters();
  }

  async loadSitters() {
    try {
      const response = await doggoClient.findAllSitters();

      this.sitters = response.sitters.map((s) => ({
        id: s.id,
        name: s.name,
        imageUrl: this.defaultSitterImage,
        yearsOfExperience: 2,
        averageRating: 4,
        specialties: [''],
      }));
    } catch (error) {
      console.error('Error cargando cuidadores:', error);
    }
  }

  handleModal(sitter: {
    id: number;
    imageUrl?: string;
    name: string;
    yearsOfExperience?: number;
    averageRating?: number;
    specialties?: string[];
  }) {
    this.open = !this.open;
  }
}
