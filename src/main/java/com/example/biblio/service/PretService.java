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
    private PretRepository pretRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private PenaliteRepository penaliteRepository;

    public List<Pret> findAllPretsActifs() {
        return pretRepository.findPretsActifs();
    }

    public String preterLivre(Integer idAdherant, Integer idExemplaire, String typePret) {
        // Validation des paramètres
        if (idAdherant == null || idExemplaire == null || typePret == null) {
            return "Tous les champs sont obligatoires.";
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

        // Vérification de la validité de l'abonnement
        LocalDate today = LocalDate.now();
        List<Abonnement> abonnementsActifs = abonnementRepository.findActiveAbonnementsByAdherantId(idAdherant, today);
        if (abonnementsActifs.isEmpty()) {
            return "Adhérant non abonné ou abonnement expiré.";
        }

        // Vérification de l'absence de pénalité active
        List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(idAdherant, today);
        if (!penalitesActives.isEmpty()) {
            return "Adhérant sous pénalité active. Impossible d'emprunter.";
        }

        // Vérification du quota d'emprunts
        if (adherant.getQuotaRestantEmprunt() <= 0) {
            return "Quota d'emprunts dépassé.";
        }

        // Vérification de la disponibilité de l'exemplaire
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            return "Exemplaire non disponible.";
        }

        // Vérification de l'âge de l'adhérant
        int ageAdherant = Period.between(adherant.getDateNaissance(), today).getYears();
        if (ageAdherant < exemplaire.getLivre().getAgeMinimum()) {
            return "Livre non adapté à l'âge de l'adhérant. Âge minimum requis : " + exemplaire.getLivre().getAgeMinimum() + " ans.";
        }

        // Calcul de la date de retour
        LocalDate dateRetourPrevue;
        if ("LECTURE_SUR_PLACE".equals(typePret)) {
            dateRetourPrevue = today; // Même jour pour lecture sur place
        } else {
            dateRetourPrevue = today.plusDays(14); // 14 jours pour emporter
        }

        // Création du prêt
        Pret.TypePret typePretEnum = Pret.TypePret.valueOf(typePret);
        Pret pret = new Pret(exemplaire, adherant, today, dateRetourPrevue, typePretEnum);

        // Mise à jour du statut de l'exemplaire
        exemplaire.setStatut(Exemplaire.StatutExemplaire.EMPRUNTE);

        // Décrémenter le quota d'emprunts
        adherant.setQuotaRestantEmprunt(adherant.getQuotaRestantEmprunt() - 1);

        // Enregistrement
        pretRepository.save(pret);
        exemplaireRepository.save(exemplaire);
        adherantRepository.save(adherant);

        return null; // Pas d'erreur
    }
}