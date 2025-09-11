package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

import java.util.List;

@Data
public class OrderRequest {
  @NotEmpty
  private List<Item> items;

  @Data
  public static class Item {
    @NotNull
    private Long productId;

    @Min(1)
    private int quantity;
  }
}
