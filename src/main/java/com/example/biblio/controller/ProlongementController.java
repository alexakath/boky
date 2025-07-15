package com.example.biblio.controller;

import com.example.biblio.model.Adherant;
import com.example.biblio.model.DemandeProlongement;
import com.example.biblio.model.Pret;
import com.example.biblio.service.ProlongementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
@RequestMapping("/adherant")
public class ProlongementController {

    @Autowired
    private ProlongementService prolongementService;

    @GetMapping("/prolongements")
    public String showProlongements(Model model, HttpSession session) {
        // Récupération de l'adhérant depuis la session
        Adherant adherant = (Adherant) session.getAttribute("adherant");
        if (adherant == null) {
            return "redirect:/adherant/login";
        }

        // Récupération des prêts actifs de l'adhérant
        List<Pret> pretsActifs = prolongementService.getPretsActifsByAdherant(adherant.getId());
        model.addAttribute("pretsActifs", pretsActifs);

        // Récupération des demandes de prolongement de l'adhérant
        List<DemandeProlongement> demandes = prolongementService.getDemandesByAdherant(adherant.getId());
        model.addAttribute("demandes", demandes);

        return "adherant/prolongements";
    }

    @PostMapping("/prolongements")
    public String demanderProlongement(
            @RequestParam("exemplaireId") Integer exemplaireId,
            @RequestParam("nouvelleDateRetour") String nouvelleDateRetourStr,
            Model model,
            HttpSession session) {

        // Récupération de l'adhérant depuis la session
        Adherant adherant = (Adherant) session.getAttribute("adherant");
        if (adherant == null) {
            return "redirect:/adherant/login";
        }

        try {
            LocalDate nouvelleDateRetour = LocalDate.parse(nouvelleDateRetourStr);

            String error = prolongementService.demanderProlongement(
                adherant.getId(), exemplaireId, nouvelleDateRetour);

            if (error != null) {
                model.addAttribute("error", error);
            } else {
                model.addAttribute("success", "Demande de prolongement envoyée avec succès. En attente de validation.");
            }

        } catch (DateTimeParseException e) {
            model.addAttribute("error", "Format de date invalide. Veuillez utiliser le format YYYY-MM-DD.");
        }

        // Rechargement des données pour affichage
        List<Pret> pretsActifs = prolongementService.getPretsActifsByAdherant(adherant.getId());
        model.addAttribute("pretsActifs", pretsActifs);

        List<DemandeProlongement> demandes = prolongementService.getDemandesByAdherant(adherant.getId());
        model.addAttribute("demandes", demandes);

        return "adherant/prolongements";
    }
}
