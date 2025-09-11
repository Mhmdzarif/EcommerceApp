package com.project.EcommerceApp.dto;

import java.time.Instant;

public class ErrorResponse {
  public Instant timestamp = Instant.now();
  public int status;
  public String error;
  public String message;
  public String path;

  public ErrorResponse(int status, String error, String message, String path) {
    this.status = status;
    this.error = error;
    this.message = message;
    this.path = path;
  }
}
