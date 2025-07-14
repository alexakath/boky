package com.example.biblio.controller;

import com.example.biblio.model.JourFerier;
import com.example.biblio.service.JourFerierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
@RequestMapping("/jours-feries")
public class JourFerierController {

    @Autowired
    private JourFerierService jourFerierService;

    @GetMapping("/gerer")
    public String showGererJoursFeries(Model model) {
        List<JourFerier> joursFeries = jourFerierService.findAllJoursFeries();
        model.addAttribute("joursFeries", joursFeries);
        return "biblio/jourFerier";
    }

    @PostMapping("/ajouter")
    public String ajouterJourFerier(
            @RequestParam("dateFerier") String dateFerier,
            @RequestParam("description") String description,
            Model model) {

        try {
            LocalDate date = LocalDate.parse(dateFerier);
            String error = jourFerierService.ajouterJourFerier(date, description);

            if (error != null) {
                model.addAttribute("error", error);
                model.addAttribute("dateFerier", dateFerier);
                model.addAttribute("description", description);
            } else {
                model.addAttribute("success", "Jour férié ajouté avec succès.");
            }
        } catch (DateTimeParseException e) {
            model.addAttribute("error", "Format de date invalide. Utilisez le format YYYY-MM-DD.");
            model.addAttribute("dateFerier", dateFerier);
            model.addAttribute("description", description);
        }

        List<JourFerier> joursFeries = jourFerierService.findAllJoursFeries();
        model.addAttribute("joursFeries", joursFeries);
        return "biblio/jourFerier";
    }

    @PostMapping("/supprimer/{id}")
    public String supprimerJourFerier(@PathVariable Integer id, Model model) {
        boolean supprime = jourFerierService.supprimerJourFerier(id);
        
        if (supprime) {
            model.addAttribute("success", "Jour férié supprimé avec succès.");
        } else {
            model.addAttribute("error", "Impossible de supprimer le jour férié.");
        }

        List<JourFerier> joursFeries = jourFerierService.findAllJoursFeries();
        model.addAttribute("joursFeries", joursFeries);
        return "biblio/jourFerier";
    }
}