package com.example.biblio.service;

import com.example.biblio.model.Abonnement;
import com.example.biblio.model.Adherant;
import com.example.biblio.model.Penalite;
import com.example.biblio.repository.AbonnementRepository;
import com.example.biblio.repository.AdherantRepository;
import com.example.biblio.repository.PenaliteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AbonnementService {

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    public String renouvelerAbonnement(Integer adherantId, LocalDate nouvelleDateFin) {
        try {
            // Vérifier que l'adhérant existe
            Optional<Adherant> adherantOpt = adherantRepository.findById(adherantId);
            if (!adherantOpt.isPresent()) {
                return "Adhérant non trouvé.";
            }

            Adherant adherant = adherantOpt.get();

            // Vérifier l'éligibilité (pas de pénalités actives)
            List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(
                    adherantId, LocalDate.now());
            if (!penalitesActives.isEmpty()) {
                return "L'adhérant a des pénalités actives. Le renouvellement n'est pas possible.";
            }

            // Trouver l'abonnement actuel (le plus récent)
            Abonnement abonnementActuel = null;
            for (Abonnement abonnement : adherant.getAbonnements()) {
                if (abonnementActuel == null || abonnement.getDateFin().isAfter(abonnementActuel.getDateFin())) {
                    abonnementActuel = abonnement;
                }
            }

            LocalDate nouvelleDateDebut;
            
            if (abonnementActuel != null) {
                // Vérifier que la nouvelle date de fin est postérieure à l'actuelle
                if (!nouvelleDateFin.isAfter(abonnementActuel.getDateFin())) {
                    return "La nouvelle date de fin doit être postérieure à la date de fin actuelle (" + 
                           abonnementActuel.getDateFin() + ").";
                }
                
                // La nouvelle date de début est le jour suivant la fin de l'abonnement actuel
                nouvelleDateDebut = abonnementActuel.getDateFin().plusDays(1);
            } else {
                // Si pas d'abonnement existant, commencer aujourd'hui
                nouvelleDateDebut = LocalDate.now();
                
                // Vérifier que la nouvelle date de fin est au moins aujourd'hui
                if (!nouvelleDateFin.isAfter(LocalDate.now()) && !nouvelleDateFin.equals(LocalDate.now())) {
                    return "La nouvelle date de fin doit être aujourd'hui ou dans le futur.";
                }
            }

            // Créer un nouveau abonnement directement via le repository
            Abonnement nouvelAbonnement = new Abonnement(adherant, nouvelleDateDebut, nouvelleDateFin);
            
            // Sauvegarder directement l'abonnement
            abonnementRepository.save(nouvelAbonnement);

            return null; // Pas d'erreur
            
        } catch (Exception e) {
            // Log l'erreur pour le debugging
            e.printStackTrace();
            return "Erreur technique lors du renouvellement : " + e.getMessage();
        }
    }

    public Optional<Adherant> findAdherantById(Integer id) {
        return adherantRepository.findById(id);
    }

    public List<Adherant> findAllAdherants() {
        return adherantRepository.findAll();
    }
    
    /**
     * Méthode utilitaire pour obtenir l'abonnement actuel d'un adhérant
     */
    public Optional<Abonnement> getAbonnementActuel(Integer adherantId) {
        Optional<Adherant> adherantOpt = adherantRepository.findById(adherantId);
        if (!adherantOpt.isPresent()) {
            return Optional.empty();
        }
        
        Adherant adherant = adherantOpt.get();
        Abonnement abonnementActuel = null;
        
        for (Abonnement abonnement : adherant.getAbonnements()) {
            if (abonnementActuel == null || abonnement.getDateFin().isAfter(abonnementActuel.getDateFin())) {
                abonnementActuel = abonnement;
            }
        }
        
        return Optional.ofNullable(abonnementActuel);
    }
    
    /**
     * Vérifier si un abonnement est encore actif
     */
    public boolean isAbonnementActif(Abonnement abonnement) {
        return abonnement != null && 
               !abonnement.getDateFin().isBefore(LocalDate.now()) &&
               !abonnement.getDateDebut().isAfter(LocalDate.now());
    }
}