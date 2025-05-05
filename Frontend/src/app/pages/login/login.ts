import { Component } from '@angular/core';
import {
  FormControl,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { Router } from '@angular/router';

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
    rememberMe: new FormControl(false),
  });
  isSubmitted = false;
  hidePassword = true;

  constructor(private router: Router) {}

  get formControls() {
    return this.loginForm.controls;
  }

  onSubmit(): void {
    this.isSubmitted = true;

    if (this.loginForm.invalid) {
      // TODO: Show a message here when something is missing
      return;
    }

    // TODO: Login logic here!! call to the API
    console.log('It woooorks', this.loginForm.value);
    // this.authService.login(this.loginForm.value.email, this.loginForm.value.password)
  }

  handleSubmit(): void {
    console.log('here');
    this.router.navigateByUrl('/pet-sitters');
  }
}
