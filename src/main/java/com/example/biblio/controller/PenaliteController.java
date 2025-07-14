package com.example.biblio.controller;

import com.example.biblio.model.Penalite;
import com.example.biblio.service.PenaliteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/penalites")
public class PenaliteController {

    @Autowired
    private PenaliteService penaliteService;

    @GetMapping("/gerer")
    public String showGererPenalites(Model model) {
        List<Penalite> penalites = penaliteService.findAllPenalitesActives();
        marquerPenalitesActives(penalites);
        model.addAttribute("penalites", penalites);
        return "biblio/penalite";
    }

    @PostMapping("/supprimer/{id}")
    public String supprimerPenalite(@PathVariable Integer id, Model model) {
        String error = penaliteService.supprimerPenalite(id);

        if (error != null) {
            model.addAttribute("error", error);
        } else {
            model.addAttribute("success", "Pénalité supprimée avec succès.");
        }

        List<Penalite> penalites = penaliteService.findAllPenalitesActives();
        marquerPenalitesActives(penalites);
        model.addAttribute("penalites", penalites);
        return "biblio/penalite";
    }

    @PostMapping("/nettoyer-expirees")
    public String nettoyerPenalitesExpirees(Model model) {
        int nombreSupprimees = penaliteService.supprimerPenalitesExpirees();

        model.addAttribute("success", nombreSupprimees + " pénalité(s) expirée(s) supprimée(s) automatiquement.");

        List<Penalite> penalites = penaliteService.findAllPenalitesActives();
        marquerPenalitesActives(penalites);
        model.addAttribute("penalites", penalites);
        return "biblio/penalite";
    }

    // ✅ Méthode utilitaire pour définir le statut actif/expiré
    private void marquerPenalitesActives(List<Penalite> penalites) {
        LocalDate today = LocalDate.now();
        for (Penalite p : penalites) {
            p.setActive(p.getDateFinPenalite().isAfter(today));
        }
    }
}
