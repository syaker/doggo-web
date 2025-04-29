import { NgFor } from '@angular/common';
import { Component } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'schedule',
  templateUrl: 'schedule.html',
  styleUrl: 'schedule.css',
  imports: [BasicLayout, NgFor],
})
export class Schedule {
  selectedDate: number | null = null;
  selectedTime: string | null = null;

  daysInMonth = Array.from({ length: 30 }, (_, i) => i + 1);

  availableTimes = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
  ];

  selectDate(day: number): void {
    this.selectedDate = day;
  }

  selectTime(time: string): void {
    this.selectedTime = time;
  }

  scheduleAppointment(): void {
    if (this.selectedDate && this.selectedTime) {
      alert(`Cita agendada para septiembre ${this.selectedDate} a las ${this.selectedTime}`);
    } else {
      alert('Por favor, selecciona fecha y hora');
    }
  }
}
