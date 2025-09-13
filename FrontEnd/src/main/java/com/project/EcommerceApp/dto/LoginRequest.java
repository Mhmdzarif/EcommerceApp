package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;

public class LoginRequest {
  @Email @NotBlank
  public String email;

  @NotBlank
  public String password;
}
