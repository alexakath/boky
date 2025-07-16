package com.example.biblio.service;

import com.example.biblio.model.*;
import com.example.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository demandeReservationRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    public List<DemandeReservation> getDemandesReservationByAdherant(Integer adherantId) {
        return demandeReservationRepository.findByAdherantIdOrderByDateDemandeDesc(adherantId);
    }

    public Exemplaire getExemplaireById(Integer exemplaireId) {
        return exemplaireRepository.findById(exemplaireId).orElse(null);
    }

    public String creerDemandeReservation(Integer adherantId, Integer exemplaireId, LocalDate dateDemande) {
        // Vérifier que l'adhérant existe
        Adherant adherant = adherantRepository.findById(adherantId).orElse(null);
        if (adherant == null) {
            return "Adhérant non trouvé.";
        }

        // Vérifier que l'exemplaire existe
        Exemplaire exemplaire = exemplaireRepository.findById(exemplaireId).orElse(null);
        if (exemplaire == null) {
            return "Exemplaire non trouvé.";
        }

        // Règle : L'exemplaire doit être indisponible
        if (exemplaire.getStatut() == Exemplaire.StatutExemplaire.DISPONIBLE) {
            return "Cet exemplaire est disponible. Vous pouvez l'emprunter directement.";
        }

        // Règle : Vérifier l'âge de l'adhérant
        int ageAdherant = Period.between(adherant.getDateNaissance(), LocalDate.now()).getYears();
        if (ageAdherant < exemplaire.getLivre().getAgeMinimum()) {
            return "Ce livre n'est pas adapté à votre âge.";
        }

        // Règle : Vérifier l'abonnement valide
        boolean abonnementValide = adherant.getAbonnements().stream()
                .anyMatch(abonnement -> !abonnement.getDateFin().isBefore(LocalDate.now()));
        if (!abonnementValide) {
            return "Votre abonnement n'est pas valide.";
        }

        // Règle : Vérifier les pénalités actives
        List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(
                adherantId, LocalDate.now());
        if (!penalitesActives.isEmpty()) {
            return "Vous avez des pénalités actives. Impossible de faire une réservation.";
        }

        // Règle : Vérifier le quota de réservations
        long nombreDemandesEnAttente = demandeReservationRepository.countByAdherantIdAndStatut(
                adherantId, DemandeReservation.StatutDemandeReservation.EN_ATTENTE);
        if (nombreDemandesEnAttente >= adherant.getQuotaRestantResa()) {
            return "Vous avez atteint votre quota de réservations.";
        }

        // Créer la demande de réservation
        DemandeReservation demandeReservation = new DemandeReservation(exemplaire, adherant, dateDemande);
        demandeReservationRepository.save(demandeReservation);

        return null; // Pas d'erreur
    }

    public void annulerDemandeReservation(Integer demandeId, Integer adherantId) {
        DemandeReservation demande = demandeReservationRepository.findById(demandeId).orElse(null);
        if (demande != null && demande.getAdherant().getId().equals(adherantId) && 
            demande.getStatut() == DemandeReservation.StatutDemandeReservation.EN_ATTENTE) {
            demande.setStatut(DemandeReservation.StatutDemandeReservation.ANNULEE);
            demandeReservationRepository.save(demande);
        }
    }
}