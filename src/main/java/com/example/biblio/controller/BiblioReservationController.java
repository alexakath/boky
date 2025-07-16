package com.example.biblio.controller;

import com.example.biblio.model.DemandeReservation;
import com.example.biblio.service.BiblioReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/reservations")
public class BiblioReservationController {

    @Autowired
    private BiblioReservationService biblioReservationService;

    @GetMapping("/gerer")
    public String gererReservations(Model model) {
        // Récupérer toutes les demandes de réservation en attente
        List<DemandeReservation> demandesEnAttente = biblioReservationService.getDemandesReservationEnAttente();
        
        model.addAttribute("demandesReservation", demandesEnAttente);
        
        return "biblio/reservationsBiblio";
    }

    @PostMapping("/valider/{id}")
    public String validerDemande(@PathVariable("id") Integer demandeId, Model model) {
        String resultat = biblioReservationService.validerDemandeReservation(demandeId);
        
        if (resultat != null) {
            model.addAttribute("errorMessage", resultat);
        } else {
            model.addAttribute("successMessage", "Demande de réservation validée avec succès.");
        }
        
        // Récupérer les demandes mises à jour
        List<DemandeReservation> demandesEnAttente = biblioReservationService.getDemandesReservationEnAttente();
        model.addAttribute("demandesReservation", demandesEnAttente);
        
        return "biblio/reservationsBiblio";
    }

    @PostMapping("/reservations/rejeter/{id}")
    public String rejeterDemande(@PathVariable("id") Integer demandeId, 
                                @RequestParam(value = "motifRefus", required = false) String motifRefus,
                                Model model) {
        String resultat = biblioReservationService.rejeterDemandeReservation(demandeId, motifRefus);
        
        if (resultat != null) {
            model.addAttribute("errorMessage", resultat);
        } else {
            model.addAttribute("successMessage", "Demande de réservation rejetée avec succès.");
        }
        
        // Récupérer les demandes mises à jour
        List<DemandeReservation> demandesEnAttente = biblioReservationService.getDemandesReservationEnAttente();
        model.addAttribute("demandesReservation", demandesEnAttente);
        
        return "biblio/reservationsBiblio";
    }
}