import { NgFor } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';
import { doggoClient } from '../../lib/doggo/client';
import { Service } from '../../lib/doggo/types';

@Component({
  standalone: true,
  selector: 'home',
  templateUrl: 'home.html',
  styleUrls: ['home.css'],
  imports: [BasicLayout, NgFor],
})
export class Home implements OnInit {
  categories: string[] = ['Box 1', 'Box 2', 'Box 3', 'Box 4'];
  services: Service[] = [];

  constructor() {}

  ngOnInit() {
    this.loadServices();
  }

  async loadServices() {
    try {
      this.services = await doggoClient.findAllServices();
    } catch (error) {
      console.error('Error cargando servicios:', error);
    }
  }
}
