package com.example.biblio.service;

import com.example.biblio.model.*;
import com.example.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class BiblioReservationService {

    @Autowired
    private ReservationRepository demandeReservationRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    public List<DemandeReservation> getDemandesReservationEnAttente() {
        return demandeReservationRepository.findByStatutOrderByDateDemandeAsc(
                DemandeReservation.StatutDemandeReservation.EN_ATTENTE);
    }

    @Transactional
    public String validerDemandeReservation(Integer demandeId) {
        // Récupérer la demande de réservation
        DemandeReservation demande = demandeReservationRepository.findById(demandeId).orElse(null);
        if (demande == null) {
            return "Demande de réservation non trouvée.";
        }

        // Vérifier que la demande est en attente
        if (demande.getStatut() != DemandeReservation.StatutDemandeReservation.EN_ATTENTE) {
            return "Cette demande a déjà été traitée.";
        }

        // Vérifier que l'exemplaire est toujours indisponible
        if (demande.getExemplaire().getStatut() == Exemplaire.StatutExemplaire.DISPONIBLE) {
            return "L'exemplaire est maintenant disponible. La réservation n'est plus nécessaire.";
        }

        // Valider la demande
        demande.setStatut(DemandeReservation.StatutDemandeReservation.ACCEPTEE);
        demande.setDateValidation(LocalDate.now());
        demandeReservationRepository.save(demande);

        // Créer la réservation effective
        Reservation reservation = new Reservation();
        reservation.setExemplaire(demande.getExemplaire());
        reservation.setAdherant(demande.getAdherant());
        reservation.setDateReservation(LocalDate.now());
        reservation.setStatut(Reservation.StatutReservation.en_attente);
        demandeReservationRepository.save(reservation);

        // Décrémenter le quota de réservation restant de l'adhérant
        Adherant adherant = demande.getAdherant();
        adherant.setQuotaRestantResa(adherant.getQuotaRestantResa() - 1);
        adherantRepository.save(adherant);

        // Marquer l'exemplaire comme réservé
        demande.getExemplaire().setStatut(Exemplaire.StatutExemplaire.RESERVE);
        exemplaireRepository.save(demande.getExemplaire());

        // Rejeter automatiquement les autres demandes pour le même exemplaire
        rejeterAutresDemandes(demande.getExemplaire().getId(), demandeId);

        return null; // Pas d'erreur
    }

    @Transactional
    public String rejeterDemandeReservation(Integer demandeId, String motifRefus) {
        // Récupérer la demande de réservation
        DemandeReservation demande = demandeReservationRepository.findById(demandeId).orElse(null);
        if (demande == null) {
            return "Demande de réservation non trouvée.";
        }

        // Vérifier que la demande est en attente
        if (demande.getStatut() != DemandeReservation.StatutDemandeReservation.EN_ATTENTE) {
            return "Cette demande a déjà été traitée.";
        }

        // Rejeter la demande
        demande.setStatut(DemandeReservation.StatutDemandeReservation.REFUSEE);
        demande.setMotifRefus(motifRefus);
        demande.setDateValidation(LocalDate.now());
        demandeReservationRepository.save(demande);

        return null; // Pas d'erreur
    }

    @Transactional
    private void rejeterAutresDemandes(Integer exemplaireId, Integer demandeValideeId) {
        // Récupérer toutes les autres demandes en attente pour le même exemplaire
        List<DemandeReservation> autresDemandes = demandeReservationRepository
                .findByExemplaireIdAndStatutOrderByDateDemandeAsc(
                        exemplaireId, DemandeReservation.StatutDemandeReservation.EN_ATTENTE);

        // Rejeter toutes les autres demandes
        for (DemandeReservation autreDemande : autresDemandes) {
            if (!autreDemande.getId().equals(demandeValideeId)) {
                autreDemande.setStatut(DemandeReservation.StatutDemandeReservation.REFUSEE);
                autreDemande.setMotifRefus("Exemplaire déjà réservé par un autre adhérent");
                autreDemande.setDateValidation(LocalDate.now());
                demandeReservationRepository.save(autreDemande);
            }
        }
    }
}