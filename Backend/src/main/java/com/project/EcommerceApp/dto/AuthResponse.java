package com.project.EcommerceApp.dto;

public class AuthResponse {
  public String token;
  public Long id;
  public String email;
  public String role;

  public AuthResponse(String token, Long id, String email, String role) {
    this.token = token;
    this.id = id;
    this.email = email;
    this.role = role;
  }
}
