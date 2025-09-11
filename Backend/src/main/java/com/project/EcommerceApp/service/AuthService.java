package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.*;
import com.project.EcommerceApp.entity.User;
import com.project.EcommerceApp.repository.UserRepository;
import com.project.EcommerceApp.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class AuthService {
  private final UserRepository userRepository;
  private final PasswordEncoder encoder;
  private final JwtUtil jwtUtil;

  public AuthService(UserRepository userRepository, PasswordEncoder encoder, JwtUtil jwtUtil) {
    this.userRepository = userRepository;
    this.encoder = encoder;
    this.jwtUtil = jwtUtil;
  }

  public AuthResponse register(RegisterRequest req) {
    if (userRepository.existsByEmail(req.email)) {
      throw new IllegalArgumentException("Email already in use");
    }
    User u = new User();
    u.setEmail(req.email);
    u.setPassword(encoder.encode(req.password));
    u.setRole(User.Role.USER);
    userRepository.save(u);

    String token = jwtUtil.generateToken(u.getEmail(),
        Map.of("role", u.getRole().name(), "uid", u.getId()));
    return new AuthResponse(token, u.getId(), u.getEmail(), u.getRole().name());
  }

  public AuthResponse login(LoginRequest req) {
    User u = userRepository.findByEmail(req.email)
        .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));

    if (!encoder.matches(req.password, u.getPassword())) {
      throw new IllegalArgumentException("Invalid credentials");
    }
    String token = jwtUtil.generateToken(u.getEmail(),
        Map.of("role", u.getRole().name(), "uid", u.getId()));
    return new AuthResponse(token, u.getId(), u.getEmail(), u.getRole().name());
  }
}
