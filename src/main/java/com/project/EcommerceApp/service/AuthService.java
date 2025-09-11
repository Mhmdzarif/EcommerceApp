package com.project.EcommerceApp.service;

import com.project.EcommerceApp.dto.*;
import com.project.EcommerceApp.entity.User;
import com.project.EcommerceApp.repository.UserRepository;
import com.project.EcommerceApp.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;
  private final JwtUtil jwtUtil;

  @Transactional
  public AuthResponse register(AuthRequest req) {
    User u = new User();
    u.setEmail(req.getEmail());
    u.setPassword(passwordEncoder.encode(req.getPassword()));
    u.setRole("USER");
    User saved = userRepository.save(u);

    String token = jwtUtil.generateToken(
      saved.getEmail(),
      Map.of("id", saved.getId(), "role", saved.getRole())
    );
    return new AuthResponse(token, saved.getEmail(), saved.getRole());
  }

  public AuthResponse login(AuthRequest req) {
    User u = userRepository.findByEmail(req.getEmail())
      .orElseThrow(() -> new RuntimeException("Invalid credentials"));
    if (!passwordEncoder.matches(req.getPassword(), u.getPassword())) {
      throw new RuntimeException("Invalid credentials");
    }
    String token = jwtUtil.generateToken(
      u.getEmail(),
      Map.of("id", u.getId(), "role", u.getRole())
    );
    return new AuthResponse(token, u.getEmail(), u.getRole());
  }
}
