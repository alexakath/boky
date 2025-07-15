package com.example.biblio.controller;

import com.example.biblio.service.AdherantLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdherantLoginController {

    @Autowired
    private AdherantLoginService adherantLoginService;

    @GetMapping("/login")
    public String showLoginPage() {
        return "adherant/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                       @RequestParam("motDePasse") String motDePasse,
                       HttpSession session,
                       Model model) {
        
        // Validation des champs
        if (email == null || email.trim().isEmpty() || 
            motDePasse == null || motDePasse.trim().isEmpty()) {
            model.addAttribute("error", "Veuillez remplir tous les champs.");
            return "adherant/login";
        }

        // Tentative de connexion
        String resultat = adherantLoginService.connecterAdherant(email, motDePasse);
        
        if (resultat != null) {
            // Erreur de connexion
            model.addAttribute("error", resultat);
            return "adherant/login";
        }

        // Connexion réussie - récupérer l'adhérant et le mettre en session
        var adherant = adherantLoginService.findAdherantByEmail(email);
        if (adherant.isPresent()) {
            session.setAttribute("adherantConnecte", adherant.get());
            return "redirect:/adherant/dashboard";
        }

        model.addAttribute("error", "Erreur technique lors de la connexion.");
        return "adherant/login";
    }

    @GetMapping("/adherant/dashboard")
    public String dashboard(HttpSession session, Model model) {
        var adherant = session.getAttribute("adherantConnecte");
        if (adherant == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("adherant", adherant);
        return "adherant/dashboard";
    }

    @GetMapping("/adherant/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
