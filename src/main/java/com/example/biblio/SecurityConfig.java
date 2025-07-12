// package com.example.biblio;

// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.web.SecurityFilterChain;

// @Configuration
// public class SecurityConfig {

//     @Bean
//     public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//         http
//             .authorizeHttpRequests(auth -> auth
//                 .requestMatchers("/", "/adherants/**", "/adherants/api/adherants", "/static/**").permitAll()
//                 .anyRequest().authenticated()
//             )
//             .formLogin(form -> form
//                 .disable() // Désactiver la page de connexion
//             )
//             .logout(logout -> logout
//                 .disable() // Désactiver la déconnexion
//             );
//         return http.build();
//     }
// }