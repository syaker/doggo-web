
import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-rates',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './rates.component.html',
  styleUrls: ['./rates.component.css']
})
export class RatesComponent implements OnInit {
  selectedRating: number = 0;
  comment: string = '';
  showConfirmation: boolean = false;
  hoverRating: number = 0;
  isLoading: boolean = false; // Asegúrate de tener esta propiedad

  constructor() { }

  ngOnInit(): void {
  }

  setRating(rating: number): void {
    this.selectedRating = rating;
  }

  setHoverRating(rating: number): void {
    this.hoverRating = rating;
  }

  resetHoverRating(): void {
    this.hoverRating = 0;
  }

  async submitRating(): Promise<void> {
    if (this.selectedRating === 0) {
      alert('Por favor selecciona una puntuación');
      return;
    }

    if (!this.comment.trim()) {
      alert('Por favor escribe un comentario');
      return;
    }

    this.isLoading = true; // Activar estado de carga

    try {
      // Simulación de envío al backend (reemplaza con tu llamada real)
      await this.sendRatingToBackend();
      
      this.showConfirmation = true;
      this.resetForm();
    } catch (error) {
      console.error('Error al enviar valoración:', error);
      alert('Ocurrió un error al enviar tu valoración');
    } finally {
      this.isLoading = false; // Desactivar estado de carga
    }
  }

  private async sendRatingToBackend(): Promise<void> {
    // Simulación de una llamada HTTP
    return new Promise(resolve => {
      setTimeout(() => {
        console.log('Valoración enviada:', {
          rating: this.selectedRating,
          comment: this.comment
        });
        resolve();
      }, 1500);
    });
  }

  private resetForm(): void {
    setTimeout(() => {
      this.selectedRating = 0;
      this.comment = '';
      this.showConfirmation = false;
    }, 3000);
  }
}