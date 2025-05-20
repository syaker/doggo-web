import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { BasicLayout } from '../../_components/BasicLayout/basic-layout';
import { doggoClient } from '../../lib/doggo/client';

interface Message {
  content: string;
  sender: 'client' | 'sitter';
}

@Component({
  selector: 'chat',
  templateUrl: 'chat.html',
  styleUrls: ['chat.css'],
  standalone: true,
  imports: [CommonModule, FormsModule, BasicLayout],
})
export class Chat {
  sitterId: number | null = null;
  message: string = '';
  messages: Message[] = [];

  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.sitterId = Number(this.route.snapshot.paramMap.get('sitterId'));

    this.messages.push({
      content: '¡Hola 😊 Soy ..., tu cuidador de mascotas...',
      sender: 'sitter',
    });
  }

  async sendMessage() {
    if (!this.message.trim()) {
      return;
    }

    const clientId = Number(localStorage.getItem('client-id'));

    if (!this.sitterId || !clientId) {
      console.error('Missing sitterId or clientId');
      return;
    }

    this.messages.push({
      content: this.message,
      sender: 'client',
    });

    const messageToSend = this.message;
    this.message = '';

    try {
      await doggoClient.sendMessage({
        content: messageToSend,
        sitterId: this.sitterId,
        clientId,
      });
    } catch (error) {
      console.error('Error enviando mensaje:', error);
    }
  }
}
