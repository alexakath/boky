package com.example.biblio.controller;

import com.example.biblio.model.Adherant;
import com.example.biblio.model.Exemplaire;
import com.example.biblio.model.DemandeReservation;
import com.example.biblio.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/adherant")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/reservations")
    public String showReservations(HttpSession session, Model model) {
        // Récupérer l'adhérant connecté depuis la session
        Adherant adherant = (Adherant) session.getAttribute("adherantConnecte");
        if (adherant == null) {
            return "redirect:/login";
        }

        // Récupérer les demandes de réservation de l'adhérant
        List<DemandeReservation> demandesReservation = reservationService.getDemandesReservationByAdherant(adherant.getId());
        
        model.addAttribute("adherant", adherant);
        model.addAttribute("demandesReservation", demandesReservation);
        
        return "adherant/reservations";
    }

    @PostMapping("/reservations/rechercher")
    public String rechercherExemplaire(
            @RequestParam("referenceExemplaire") String referenceExemplaire,
            HttpSession session,
            Model model) {
        
        Adherant adherant = (Adherant) session.getAttribute("adherantConnecte");
        if (adherant == null) {
            return "redirect:/login";
        }

        try {
            Integer exemplaireId = Integer.parseInt(referenceExemplaire);
            Exemplaire exemplaire = reservationService.getExemplaireById(exemplaireId);
            
            if (exemplaire != null) {
                model.addAttribute("exemplaire", exemplaire);
                model.addAttribute("exemplaireDisponible", exemplaire.getStatut() == Exemplaire.StatutExemplaire.DISPONIBLE);
            } else {
                model.addAttribute("errorMessage", "Exemplaire non trouvé avec cette référence.");
            }
        } catch (NumberFormatException e) {
            model.addAttribute("errorMessage", "Référence d'exemplaire invalide.");
        }

        // Récupérer les demandes de réservation pour l'affichage
        List<DemandeReservation> demandesReservation = reservationService.getDemandesReservationByAdherant(adherant.getId());
        model.addAttribute("adherant", adherant);
        model.addAttribute("demandesReservation", demandesReservation);
        
        return "adherant/reservations";
    }

    @PostMapping("/reservations/reserver")
    public String reserverExemplaire(
            @RequestParam("exemplaireId") Integer exemplaireId,
            HttpSession session,
            Model model) {
        
        Adherant adherant = (Adherant) session.getAttribute("adherantConnecte");
        if (adherant == null) {
            return "redirect:/login";
        }

        String resultat = reservationService.creerDemandeReservation(adherant.getId(), exemplaireId, LocalDate.now());
        
        if (resultat != null) {
            model.addAttribute("errorMessage", resultat);
        } else {
            model.addAttribute("successMessage", "Demande de réservation envoyée avec succès. En attente de validation du bibliothécaire.");
        }

        // Récupérer les demandes de réservation pour l'affichage
        List<DemandeReservation> demandesReservation = reservationService.getDemandesReservationByAdherant(adherant.getId());
        model.addAttribute("adherant", adherant);
        model.addAttribute("demandesReservation", demandesReservation);
        
        return "adherant/reservations";
    }

    @PostMapping("/reservations/annuler/{id}")
    public String annulerDemande(@PathVariable("id") Integer demandeId, HttpSession session) {
        Adherant adherant = (Adherant) session.getAttribute("adherantConnecte");
        if (adherant == null) {
            return "redirect:/login";
        }

        reservationService.annulerDemandeReservation(demandeId, adherant.getId());
        
        return "redirect:/adherant/reservations";
    }
}
