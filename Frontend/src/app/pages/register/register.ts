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
  selector: 'app-register',
  imports: [FormsModule, ReactiveFormsModule],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register {
  registerForm: FormGroup = new FormGroup({
    email: new FormControl('', [Validators.required, Validators.email]),
    password: new FormControl('', [Validators.required, Validators.minLength(6)]),
    confirmPassword: new FormControl('', [Validators.minLength(6)]),
    name: new FormControl('', [Validators.required]),
    surname: new FormControl('', [Validators.required]),
    termsAccepted: new FormControl(true, Validators.requiredTrue),
  });

  constructor(private router: Router) {}

  async onSubmit() {
    if (!this.registerForm.valid) {
      console.log('Please fill all required fields correctly', this.registerForm.value);
      return;
    }

    const result = await userClient.register(
      this.registerForm.value.email,
      this.registerForm.value.password,
      this.registerForm.value.name,
      this.registerForm.value.surname,
      this.registerForm.value.termsAccepted,
    );

    if (!result) {
      console.log(
        'There was an error trying to register the user, try log in',
        this.registerForm.value,
      );
      this.router.navigate(['/login']);
      return;
    }

    this.router.navigate(['/pet-sitters']);
  }
}
