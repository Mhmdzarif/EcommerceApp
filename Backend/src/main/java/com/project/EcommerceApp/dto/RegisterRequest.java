package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;

public class RegisterRequest {
  @Email @NotBlank
  public String email;

  @NotBlank @Size(min = 6, max = 100)
  public String password;
}
