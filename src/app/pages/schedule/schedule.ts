import { Component } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';

@Component({
  standalone: true,
  selector: 'schedule',
  templateUrl: 'schedule.html',
  styleUrl: 'schedule.css',
  imports: [BasicLayout],
})
export class Schedule {}
