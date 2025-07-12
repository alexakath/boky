package com.example.biblio.controller;

import com.example.biblio.model.Adherant;
import com.example.biblio.service.AdherantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/adherants")
public class AdherantController {

    @Autowired
    private AdherantService adherantService;

    @GetMapping("/ajouter")
    public String showAjouterAdherant(Model model) {
        model.addAttribute("typesAdherant", adherantService.findAllTypesAdherant());
        model.addAttribute("adherants", adherantService.findAllAdherants());
        return "biblio/ajouter-adherant";
    }

    @PostMapping("/ajouter")
    public String ajouterAdherant(
            @RequestParam("nom") String nom,
            @RequestParam("prenom") String prenom,
            @RequestParam("dateNaissance") String dateNaissance,
            @RequestParam("email") String email,
            @RequestParam("motDePasse") String motDePasse,
            @RequestParam("typeAdherantId") Integer typeAdherantId,
            @RequestParam("dateDebut") String dateDebut,
            Model model) {

        String error = adherantService.addAdherant(
                nom, prenom, LocalDate.parse(dateNaissance), email, motDePasse,
                typeAdherantId, LocalDate.parse(dateDebut));

        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("typesAdherant", adherantService.findAllTypesAdherant());
            model.addAttribute("adherants", adherantService.findAllAdherants());
            return "biblio/ajouter-adherant";
        }

        return "redirect:/adherants/ajouter";
    }

    @GetMapping("/modifier/{id}")
    public String showModifierAdherant(@PathVariable("id") Integer id, Model model) {
        Adherant adherant = adherantService.findAdherantById(id)
                .orElseThrow(() -> new IllegalArgumentException("Adhérant non trouvé."));
        model.addAttribute("adherant", adherant);
        model.addAttribute("typesAdherant", adherantService.findAllTypesAdherant());
        model.addAttribute("adherants", adherantService.findAllAdherants());
        return "biblio/ajouter-adherant";
    }

    @PostMapping("/modifier/{id}")
    public String modifierAdherant(
            @PathVariable("id") Integer id,
            @RequestParam("nom") String nom,
            @RequestParam("prenom") String prenom,
            @RequestParam("dateNaissance") String dateNaissance,
            @RequestParam("email") String email,
            @RequestParam("motDePasse") String motDePasse,
            @RequestParam("typeAdherantId") Integer typeAdherantId,
            @RequestParam("dateDebut") String dateDebut,
            Model model) {

        String error = adherantService.updateAdherant(
                id, nom, prenom, LocalDate.parse(dateNaissance), email, motDePasse,
                typeAdherantId, LocalDate.parse(dateDebut));

        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("adherant", adherantService.findAdherantById(id).orElse(null));
            model.addAttribute("typesAdherant", adherantService.findAllTypesAdherant());
            model.addAttribute("adherants", adherantService.findAllAdherants());
            return "biblio/ajouter-adherant";
        }

        return "redirect:/adherants/ajouter";
    }

    @PostMapping("/supprimer/{id}")
    public String supprimerAdherant(@PathVariable("id") Integer id) {
        adherantService.deleteAdherant(id);
        return "redirect:/adherants/ajouter";
    }
}