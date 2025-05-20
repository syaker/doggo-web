import { Component } from '@angular/core';
import {
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { Router } from '@angular/router';
import { userClient } from '../../lib/user/client';

@Component({
  standalone: true,
  selector: 'login',
  templateUrl: 'login.html',
  styleUrl: 'login.css',
  imports: [FormsModule, ReactiveFormsModule],
})
export class Login {
  loginForm = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.email]),
    password: new FormControl('', [Validators.required, Validators.minLength(6)]),
  });
  isSubmitted = false;
  hidePassword = true;
  isLogged = false;

  constructor(private router: Router) {}

  async handleSubmit(): Promise<void> {
    if (this.loginForm.invalid || !this.loginForm.value.email || !this.loginForm.value.password) {
      console.log('Please fill al required fields', this.loginForm.value);
      return;
    }

    const response = await userClient.login(
      this.loginForm.value.email,
      this.loginForm.value.password,
    );

    localStorage.setItem('auth-token', response.token);
    localStorage.setItem('client-id', String(response.id));

    this.isLogged = true;

    if (!this.isLogged) {
      console.log('There was an error trying to log in', this.loginForm.value);
    }

    if (this.isLogged) {
      this.router.navigateByUrl('/pet-sitters');
    } else {
      console.error('There was an error trying to log in');
    }
  }
}
