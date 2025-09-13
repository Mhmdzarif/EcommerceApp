package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

@Data
public class ProductRequest {
  @NotBlank
  private String name;

  private String description;

  @Positive
  private double price;

  @Min(0)
  private int stock;

  private String thumbnail;
}
