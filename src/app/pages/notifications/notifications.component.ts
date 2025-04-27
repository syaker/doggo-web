import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-notificaciones',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './notifications.component.html',
  styleUrls: ['./notifications.component.css']
})
export class NotificationsComponent implements OnInit {
  config = {
    notifCitas: true,
    notifMensajes: true,
    tipoNotificacion: 'email'
  };

  mostrarConfirmacion = false;
  isLoading = false;

  ngOnInit(): void {
    // Simular carga de configuración desde backend
    setTimeout(() => {
      // Esto sería reemplazado por una llamada HTTP real
      this.config = {
        notifCitas: true,
        notifMensajes: true,
        tipoNotificacion: 'email'
      };
    }, 500);
  }

  guardarConfiguracion(): void {
    this.isLoading = true;
    
    // Simular envío al backend
    setTimeout(() => {
      console.log('Configuración guardada:', this.config);
      this.mostrarConfirmacion = true;
      this.isLoading = false;
      
      // Ocultar mensaje después de 3 segundos
      setTimeout(() => {
        this.mostrarConfirmacion = false;
      }, 3000);
    }, 1000);
  }

  simularNotificacionPush(mensaje: string): void {
    // En una aplicación real, esto sería manejado por el servicio de notificaciones
    alert(`📬 Nueva notificación: ${mensaje}`);
  }
}
