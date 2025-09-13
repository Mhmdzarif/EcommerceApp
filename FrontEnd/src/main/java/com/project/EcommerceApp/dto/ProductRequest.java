package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;

public class ProductRequest {
  @NotBlank
  public String name;

  public String description;

  @Positive
  public double price;

  @Min(0)
  public int stock;

  public String thumbnail; // optional
}
