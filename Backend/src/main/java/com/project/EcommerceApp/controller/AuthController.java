package com.project.EcommerceApp.controller;

import com.project.EcommerceApp.dto.*;
import com.project.EcommerceApp.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

  private final AuthService authService;

  public AuthController(AuthService authService) {
    this.authService = authService;
  }

  @PostMapping("/register")
  public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest req) {
    var res = authService.register(req);
    return ResponseEntity.status(201).body(res);
  }

  @PostMapping("/login")
  public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest req) {
    var res = authService.login(req);
    return ResponseEntity.ok(res);
  }
}
