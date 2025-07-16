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

    public String preterLivre(Integer idAdherant, Integer idExemplaire, LocalDate datePret, String typePret) {
        // Validation des paramètres
        if (idAdherant == null || idExemplaire == null || datePret == null || typePret == null) {
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

        // Vérification de la validité de l'abonnement à la date de prêt
        List<Abonnement> abonnementsActifs = abonnementRepository.findActiveAbonnementsByAdherantId(idAdherant, datePret);
        if (abonnementsActifs.isEmpty()) {
            return "L'adhérant n'a pas d'abonnement valide à la date de prêt sélectionnée (" + datePret + ").";
        }

        // Vérification de l'absence de pénalité active à la date de prêt
        List<Penalite> penalitesActives = penaliteRepository.findByAdherantIdAndDateFinPenaliteAfter(idAdherant, datePret);
        if (!penalitesActives.isEmpty()) {
            return "Adhérant sous pénalité active à la date de prêt sélectionnée. Impossible d'emprunter.";
        }

        // Vérification du quota d'emprunts
        if (adherant.getQuotaRestantEmprunt() <= 0) {
            return "Quota d'emprunts dépassé.";
        }

        // Vérification de la disponibilité de l'exemplaire
        if (exemplaire.getStatut() != Exemplaire.StatutExemplaire.DISPONIBLE) {
            return "Exemplaire non disponible.";
        }

        // Vérification de l'âge de l'adhérant à la date de prêt
        int ageAdherant = Period.between(adherant.getDateNaissance(), datePret).getYears();
        if (ageAdherant < exemplaire.getLivre().getAgeMinimum()) {
            return "Livre non adapté à l'âge de l'adhérant à la date de prêt. Âge minimum requis : " + 
                   exemplaire.getLivre().getAgeMinimum() + " ans. Âge de l'adhérant à cette date : " + ageAdherant + " ans.";
        }

        // Calcul de la date de retour basée sur le type d'adhérant et le type de prêt
        LocalDate dateRetourPrevue;
        if ("LECTURE_SUR_PLACE".equals(typePret)) {
            dateRetourPrevue = datePret; // Même jour pour lecture sur place
        } else {
            // Pour les prêts à emporter, utiliser le nombre de jours de prêt du type d'adhérant
            int joursPret = adherant.getTypeAdherant().getJoursPret();
            dateRetourPrevue = datePret.plusDays(joursPret);
        }

        // Création du prêt
        Pret.TypePret typePretEnum = Pret.TypePret.valueOf(typePret);
        Pret pret = new Pret(exemplaire, adherant, datePret, dateRetourPrevue, typePretEnum);

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

    // Méthode pour maintenir la compatibilité avec l'ancienne version
    public String preterLivre(Integer idAdherant, Integer idExemplaire, String typePret) {
        return preterLivre(idAdherant, idExemplaire, LocalDate.now(), typePret);
    }

    // Méthode utilitaire pour calculer la date de retour prévue
    public LocalDate calculerDateRetourPrevue(Integer idAdherant, LocalDate datePret, String typePret) {
        if ("LECTURE_SUR_PLACE".equals(typePret)) {
            return datePret;
        }
        
        Optional<Adherant> adherantOpt = adherantRepository.findById(idAdherant);
        if (adherantOpt.isPresent()) {
            int joursPret = adherantOpt.get().getTypeAdherant().getJoursPret();
            return datePret.plusDays(joursPret);
        }
        
        // Valeur par défaut si l'adhérant n'est pas trouvé
        return datePret.plusDays(14);
    }
}