package com.example.biblio.service;

import com.example.biblio.model.*;
import com.example.biblio.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.Optional;

@Service
public class PretService {

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    public List<Adherant> findAllAdherants() {
        return adherantRepository.findAll();
    }

    public List<Exemplaire> findAllExemplairesDisponibles() {
        return exemplaireRepository.findAll().stream()
                .filter(e -> e.getStatut() == Exemplaire.StatutExemplaire.DISPONIBLE)
                .collect(java.util.stream.Collectors.toList());
    }

    public String preterLivre(Integer adherantId, Integer exemplaireId, String typePret) {
        // Validation des paramètres
        if (adherantId == null || exemplaireId == null || typePret == null) {
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

        Exemplaire exemplaire = exemplaireOpt.get();

        // Vérification de la disponibilité de l'exemplaire
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            return "Exemplaire non disponible.";
        }

        // Vérification de l'abonnement valide
        LocalDate dateActuelle = LocalDate.now();
        boolean abonnementValide = false;
        for (Abonnement abonnement : adherant.getAbonnements()) {
            if (!dateActuelle.isBefore(abonnement.getDateDebut()) && 
                !dateActuelle.isAfter(abonnement.getDateFin())) {
                abonnementValide = true;
                break;
            }
        }

        if (!abonnementValide) {
            return "Adhérant non abonné ou abonnement expiré.";
        }

        // Vérification du quota d'emprunts
        if (adherant.getQuotaRestantEmprunt() <= 0) {
            return "Quota d'emprunts dépassé.";
        }

        // Vérification de l'absence de pénalité active
        List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(
            adherantId, dateActuelle);
        if (!penalitesActives.isEmpty()) {
            return "Adhérant sous pénalité active.";
        }

        // Vérification de l'âge pour les livres avec restriction
        int ageAdherant = Period.between(adherant.getDateNaissance(), dateActuelle).getYears();
        if (ageAdherant < exemplaire.getLivre().getAgeMinimum()) {
            return "Livre non adapté à l'âge de l'adhérant.";
        }

        // Détermination de la date de retour
        LocalDate dateRetourPrevue;
        if ("lecture_sur_place".equals(typePret)) {
            dateRetourPrevue = dateActuelle; // Même jour pour lecture sur place
        } else {
            dateRetourPrevue = dateActuelle.plusDays(14); // 14 jours pour emporter
        }

        // Création du prêt
        Pret pret = new Pret();
        pret.setExemplaire(exemplaire);
        pret.setAdherant(adherant);
        pret.setDatePret(dateActuelle);
        pret.setDateRetourPrevue(dateRetourPrevue);
        pret.setTypePret("lecture_sur_place".equals(typePret) ? 
                        Pret.TypePret.LECTURE_SUR_PLACE : Pret.TypePret.A_EMPORTER);

        // Mise à jour du statut de l'exemplaire
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EMPRUNTE);

        // Décrément du quota d'emprunts
        adherant.setQuotaRestantEmprunt(adherant.getQuotaRestantEmprunt() - 1);

        // Enregistrement
        pretRepository.save(pret);
        exemplaireRepository.save(exemplaire);
        adherantRepository.save(adherant);

        return null; // Pas d'erreur
    }
}