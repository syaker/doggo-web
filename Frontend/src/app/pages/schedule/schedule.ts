import { AsyncPipe, CommonModule, NgFor } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';
import { doggoClient } from '../../lib/doggo/client';

@Component({
  standalone: true,
  selector: 'schedule',
  templateUrl: 'schedule.html',
  styleUrls: ['schedule.css'],
  imports: [BasicLayout, CommonModule, NgFor, AsyncPipe],
})
export class Schedule implements OnInit {
  selectedDate: string | null = null;
  selectedTime: string | null = null;

  availability$ = null as Promise<{
    days_available: { appointment_date: string; appointment_range: string }[];
  }> | null;

  sitterId!: number;
  clientId!: number;

  daysAvailable: string[] = [];
  availableTimes: string[] = [];

  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.sitterId = Number(this.route.snapshot.paramMap.get('sitterId'));
    const clientId = localStorage.getItem('client-id');

    if (!clientId) {
      return;
    }

    this.clientId = Number(clientId);
    this.loadAvailability();
  }

  async loadAvailability() {
    this.availability$ = doggoClient.getAvailabilityBySitterId(this.sitterId);
    const availability = await this.availability$;
    this.daysAvailable = [...new Set(availability.days_available.map((d) => d.appointment_date))];
  }

  selectDate(date: string) {
    this.selectedDate = date;
    this.availableTimes = [];

    if (!this.availability$) {
      return;
    }

    this.availability$.then((avail) => {
      this.availableTimes = avail.days_available
        .filter((d) => d.appointment_date === date)
        .map((d) => d.appointment_range);
    });
  }

  selectTime(time: string) {
    this.selectedTime = time;
  }

  async scheduleAppointment() {
    if (!this.selectedDate || !this.selectedTime) {
      alert('Por favor, selecciona fecha y hora');
      return;
    }

    try {
      const success = await doggoClient.scheduleAppointment({
        sitterId: this.sitterId,
        clientId: this.clientId,
        appointmentDate: this.selectedDate,
        appointmentRange: this.selectedTime,
      });

      if (success) {
        alert(`Cita agendada para ${this.selectedDate} a las ${this.selectedTime}`);
      } else {
        alert('Error agendando cita. Intenta de nuevo.');
      }
    } catch (error) {
      alert('Error al comunicarse con el servidor.');
      console.error(error);
    }
  }
}
