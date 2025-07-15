package com.example.biblio.service;

import com.example.biblio.model.*;
import com.example.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class ProlongementService {

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private DemandeProlongementRepository demandeProlongementRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    public List<Pret> getPretsActifsByAdherant(Integer adherantId) {
        return pretRepository.findPretsActifsByAdherant(adherantId);
    }

    public List<DemandeProlongement> getDemandesByAdherant(Integer adherantId) {
        return demandeProlongementRepository.findByAdherantId(adherantId);
    }

    public String demanderProlongement(Integer adherantId, Integer exemplaireId, LocalDate nouvelleDateRetour) {
        // Validation des paramètres
        if (adherantId == null || exemplaireId == null || nouvelleDateRetour == null) {
            return "Tous les champs sont obligatoires.";
        }

        // Vérification de l'existence de l'adhérant
        Optional<Adherant> adherantOpt = adherantRepository.findById(adherantId);
        if (!adherantOpt.isPresent()) {
            return "Adhérant non trouvé.";
        }

        Adherant adherant = adherantOpt.get();

        // Vérification de l'existence de l'exemplaire
        Optional<Exemplaire> exemplaireOpt = exemplaireRepository.findById(exemplaireId);
        if (!exemplaireOpt.isPresent()) {
            return "Exemplaire non trouvé.";
        }

        // Recherche du prêt actif pour cet adhérant et cet exemplaire
        List<Pret> pretsActifs = pretRepository.findPretsActifsByAdherant(adherantId);
        Pret pretActif = null;
        
        for (Pret pret : pretsActifs) {
            if (pret.getExemplaire().getId().equals(exemplaireId)) {
                pretActif = pret;
                break;
            }
        }

        if (pretActif == null) {
            return "Exemplaire non emprunté par cet adhérant.";
        }

        // Vérification que la nouvelle date est postérieure à la date de retour prévue actuelle
        if (!nouvelleDateRetour.isAfter(pretActif.getDateRetourPrevue())) {
            return "La nouvelle date de retour doit être postérieure à la date de retour prévue actuelle.";
        }

        // Vérification du nombre de prolongements autorisés
        if (pretActif.getNombreProlongements() >= adherant.getTypeAdherant().getQuotaProlongements()) {
            return "Nombre maximum de prolongements atteint.";
        }

        // Vérification qu'aucune réservation n'existe pour cet exemplaire
        List<Reservation> reservationsEnAttente = reservationRepository.findByExemplaireIdAndStatutOrderByDateReservationAsc(
            exemplaireId, Reservation.StatutReservation.EN_ATTENTE);
        
        if (!reservationsEnAttente.isEmpty()) {
            return "Prolongement non autorisé, exemplaire réservé.";
        }

        // Vérification de l'absence de pénalité active
        LocalDate dateActuelle = LocalDate.now();
        List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(adherantId, dateActuelle);
        if (!penalitesActives.isEmpty()) {
            return "Prolongement non autorisé, vous avez une sanction active.";
        }

        // Vérification de la validité de l'abonnement
        List<Abonnement> abonnementsActifs = abonnementRepository.findActiveAbonnementsByAdherantId(adherantId, dateActuelle);
        if (abonnementsActifs.isEmpty()) {
            return "Abonnement non valide.";
        }

        // Vérification qu'il n'y a pas déjà une demande en attente pour ce prêt
        long demandesEnAttente = demandeProlongementRepository.countDemandesEnAttenteByPretId(pretActif.getId());
        if (demandesEnAttente > 0) {
            return "Une demande de prolongement est déjà en attente pour ce prêt.";
        }

        // Création de la demande de prolongement
        DemandeProlongement demande = new DemandeProlongement(pretActif, nouvelleDateRetour, dateActuelle);
        demandeProlongementRepository.save(demande);

        return null; // Pas d'erreur, demande créée avec succès
    }
}