package com.project.EcommerceApp.dto;

import jakarta.validation.constraints.*;
import java.util.List;

public class OrderRequest {
  @NotEmpty
  public List<Item> items;

  public static class Item {
    @NotNull
    public Long productId;

    @Min(1)
    public int quantity;
  }
}
