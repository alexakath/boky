package com.example.biblio.service;

import com.example.biblio.model.*;
import com.example.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class RetourService {

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private JourFerierService jourFerierService;

    public List<Pret> findAllPretsActifs() {
        return pretRepository.findPretsActifs();
    }

    public String rendreLivre(Integer idAdherant, Integer idExemplaire, LocalDate dateRetourReelle, Integer joursPenalite) {
        // Validation des paramètres
        if (idAdherant == null || idExemplaire == null || dateRetourReelle == null) {
            return "Tous les champs sont obligatoires.";
        }

        // Vérifier si la date de retour est un jour férié
        if (jourFerierService.isJourFerier(dateRetourReelle)) {
            return "Cette date est un jour férié. Veuillez choisir une date postérieure au jour férié.";
        }

        // Vérification de l'existence de l'adhérant
        Optional<Adherant> adherantOpt = adherantRepository.findById(idAdherant);
        if (!adherantOpt.isPresent()) {
            return "Adhérant non trouvé.";
        }

        // Vérification de l'existence de l'exemplaire
        Optional<Exemplaire> exemplaireOpt = exemplaireRepository.findById(idExemplaire);
        if (!exemplaireOpt.isPresent()) {
            return "Exemplaire non trouvé.";
        }

        Adherant adherant = adherantOpt.get();
        Exemplaire exemplaire = exemplaireOpt.get();

        // Recherche du prêt actif pour cet adhérant et cet exemplaire
        List<Pret> pretsActifs = pretRepository.findPretsActifsByAdherant(idAdherant);
        Pret pretActif = null;
        
        for (Pret pret : pretsActifs) {
            if (pret.getExemplaire().getId().equals(idExemplaire)) {
                pretActif = pret;
                break;
            }
        }

        if (pretActif == null) {
            return "Exemplaire non emprunté par cet adhérant.";
        }

        // Vérification de la date de retour
        if (dateRetourReelle.isBefore(pretActif.getDatePret())) {
            return "La date de retour ne peut pas être antérieure à la date d'emprunt.";
        }

        // Calcul du retard
        boolean enRetard = dateRetourReelle.isAfter(pretActif.getDateRetourPrevue());
        
        // Gestion des pénalités
        if (enRetard) {
            // Utiliser le nombre de jours de pénalité fixe du type d'adhérant
            int joursPenaliteFixe = adherant.getTypeAdherant().getJoursPenalite();
            
            // Vérification de sécurité : s'assurer que le nombre de jours n'est pas 0
            if (joursPenaliteFixe <= 0) {
                // Valeurs par défaut selon le type d'adhérant si non configuré
                String nomType = adherant.getTypeAdherant().getNomType().toLowerCase();
                if (nomType.contains("étudiant") || nomType.contains("student")) {
                    joursPenaliteFixe = 3;
                } else if (nomType.contains("professionnel") || nomType.contains("professional")) {
                    joursPenaliteFixe = 5;
                } else if (nomType.contains("professeur") || nomType.contains("teacher")) {
                    joursPenaliteFixe = 7;
                } else {
                    joursPenaliteFixe = 5; // Valeur par défaut
                }
            }
            
            // Créer une pénalité
            LocalDate dateDebutPenalite = dateRetourReelle;
            LocalDate dateFinPenalite = dateRetourReelle.plusDays(joursPenaliteFixe);
            
            Penalite penalite = new Penalite(
                adherant, 
                pretActif, 
                Penalite.TypePenalite.RETARD, 
                dateDebutPenalite, 
                joursPenaliteFixe, 
                dateFinPenalite
            );
            
            penaliteRepository.save(penalite);
        }

        // Marquer le prêt comme terminé
        pretActif.setDateRetourReelle(dateRetourReelle);

        // Vérifier s'il existe une réservation pour cet exemplaire
        List<Reservation> reservationsEnAttente = reservationRepository.findByExemplaireIdAndStatutOrderByDateReservationAsc(
            idExemplaire, Reservation.StatutReservation.EN_ATTENTE);

        if (!reservationsEnAttente.isEmpty()) {
            // Marquer l'exemplaire comme réservé
            exemplaire.setStatut(Exemplaire.StatutExemplaire.RESERVE);
            
            // Marquer la première réservation comme honorée
            Reservation premiereReservation = reservationsEnAttente.get(0);
            premiereReservation.setStatut(Reservation.StatutReservation.HONOREE);
            reservationRepository.save(premiereReservation);
        } else {
            // Marquer l'exemplaire comme disponible
            exemplaire.setStatut(Exemplaire.StatutExemplaire.DISPONIBLE);
        }

        // Incrémenter le quota d'emprunts de l'adhérant
        adherant.setQuotaRestantEmprunt(adherant.getQuotaRestantEmprunt() + 1);

        // Enregistrer les modifications
        pretRepository.save(pretActif);
        exemplaireRepository.save(exemplaire);
        adherantRepository.save(adherant);

        return null; // Pas d'erreur
    }
}