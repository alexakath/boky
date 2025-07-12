package com.example.biblio.service;

import com.example.biblio.model.Adherant;
import com.example.biblio.model.Abonnement;
import com.example.biblio.model.TypeAdherant;
import com.example.biblio.repository.AdherantRepository;
import com.example.biblio.repository.TypeAdherantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class AdherantService {

    @Autowired
    private AdherantRepository adherantRepository;

    @Autowired
    private TypeAdherantRepository typeAdherantRepository;

    public List<Adherant> findAllAdherants() {
        return adherantRepository.findAll();
    }

    public List<TypeAdherant> findAllTypesAdherant() {
        return typeAdherantRepository.findAll();
    }

    public Optional<Adherant> findAdherantById(Integer id) {
        return adherantRepository.findById(id);
    }

    public String addAdherant(String nom, String prenom, LocalDate dateNaissance, String email, String motDePasse,
                             Integer typeAdherantId, LocalDate dateDebut) {
        // Validation des champs obligatoires
        if (nom == null || nom.trim().isEmpty() ||
            prenom == null || prenom.trim().isEmpty() ||
            dateNaissance == null ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty() ||
            typeAdherantId == null ||
            dateDebut == null) {
            return "Tous les champs obligatoires doivent être remplis.";
        }

        // Vérification de l'unicité de l'email
        if (adherantRepository.findByEmail(email).isPresent()) {
            return "Cet email est déjà utilisé.";
        }

        // Vérification du type d'adhérant
        Optional<TypeAdherant> typeAdherantOpt = typeAdherantRepository.findById(typeAdherantId);
        if (!typeAdherantOpt.isPresent()) {
            return "Type d'adhérant invalide.";
        }

        TypeAdherant typeAdherant = typeAdherantOpt.get();

        // Calculer la date de fin (1 an après la date de début)
        LocalDate dateFin = dateDebut.plusYears(1);

        // Création de l'adhérant
        Adherant adherant = new Adherant(nom, prenom, dateNaissance, email, typeAdherant, motDePasse);
        adherant.setQuotaRestantEmprunt(typeAdherant.getQuotaEmprunts());
        adherant.setQuotaRestantResa(typeAdherant.getQuotaReservations());
        adherant.setQuotaRestantProlog(typeAdherant.getQuotaProlongements());

        // Création de l'abonnement
        Abonnement abonnement = new Abonnement(adherant, dateDebut, dateFin);
        adherant.getAbonnements().add(abonnement);

        // Enregistrement dans la base
        adherantRepository.save(adherant);

        return null; // Pas d'erreur
    }

    public void deleteAdherant(Integer id) {
        adherantRepository.deleteById(id);
    }

    public String updateAdherant(Integer id, String nom, String prenom, LocalDate dateNaissance, String email,
                                String motDePasse, Integer typeAdherantId, LocalDate dateDebut) {
        Optional<Adherant> adherantOpt = adherantRepository.findById(id);
        if (!adherantOpt.isPresent()) {
            return "Adhérant non trouvé.";
        }

        Adherant adherant = adherantOpt.get();

        // Validation des champs obligatoires
        if (nom == null || nom.trim().isEmpty() ||
            prenom == null || prenom.trim().isEmpty() ||
            dateNaissance == null ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty() ||
            typeAdherantId == null ||
            dateDebut == null) {
            return "Tous les champs obligatoires doivent être remplis.";
        }

        // Vérification de l'unicité de l'email
        Optional<Adherant> existingAdherant = adherantRepository.findByEmail(email);
        if (existingAdherant.isPresent() && !existingAdherant.get().getId().equals(id)) {
            return "Cet email est déjà utilisé.";
        }

        // Vérification du type d'adhérant
        Optional<TypeAdherant> typeAdherantOpt = typeAdherantRepository.findById(typeAdherantId);
        if (!typeAdherantOpt.isPresent()) {
            return "Type d'adhérant invalide.";
        }

        TypeAdherant typeAdherant = typeAdherantOpt.get();

        // Calculer la date de fin (1 an après la date de début)
        LocalDate dateFin = dateDebut.plusYears(1);

        // Mise à jour de l'adhérant
        adherant.setNom(nom);
        adherant.setPrenom(prenom);
        adherant.setDateNaissance(dateNaissance);
        adherant.setEmail(email);
        adherant.setMotDePasse(motDePasse);
        adherant.setTypeAdherant(typeAdherant);
        adherant.setQuotaRestantEmprunt(typeAdherant.getQuotaEmprunts());
        adherant.setQuotaRestantResa(typeAdherant.getQuotaReservations());
        adherant.setQuotaRestantProlog(typeAdherant.getQuotaProlongements());

        // Mise à jour de l'abonnement (supposons un seul abonnement actif)
        if (!adherant.getAbonnements().isEmpty()) {
            Abonnement abonnement = adherant.getAbonnements().iterator().next();
            abonnement.setDateDebut(dateDebut);
            abonnement.setDateFin(dateFin);
        } else {
            Abonnement abonnement = new Abonnement(adherant, dateDebut, dateFin);
            adherant.getAbonnements().add(abonnement);
        }

        // Enregistrement
        adherantRepository.save(adherant);

        return null; // Pas d'erreur
    }
}