package com.project.EcommerceApp.service;

import com.project.EcommerceApp.entity.User;
import com.project.EcommerceApp.repository.UserRepository;
import org.springframework.stereotype.Component;

@Component
public class UserFacade {
  private final UserRepository userRepository;

  public UserFacade(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  public Long getUserIdByEmail(String email) {
    User u = userRepository.findByEmail(email)
        .orElseThrow(() -> new IllegalArgumentException("User not found"));
    return u.getId();
  }
}
