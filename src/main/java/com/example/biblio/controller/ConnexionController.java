package com.example.biblio.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ConnexionController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @PostMapping("/choix-connexion")
    public String choixConnexion(@RequestParam("type") String type) {
        if ("adherant".equals(type)) {
            return "redirect:/login";
        } else if ("bibliothecaire".equals(type)) {
            return "redirect:/accueil";
        }
        return "redirect:/";
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "adherant/login";
    }

    @GetMapping("/accueil")
    public String showAccueilPage() {
        return "biblio/accueil";
    }

}