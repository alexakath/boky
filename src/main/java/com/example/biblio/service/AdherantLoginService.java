package com.example.biblio.service;

import com.example.biblio.model.Adherant;
import com.example.biblio.model.Abonnement;
import com.example.biblio.repository.AdherantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class AdherantLoginService {

    @Autowired
    private AdherantRepository adherantRepository;

    /**
     * Connecte un adhérant selon les règles de gestion
     * @param email Email de l'adhérant
     * @param motDePasse Mot de passe de l'adhérant
     * @return null si connexion réussie, sinon message d'erreur
     */
    public String connecterAdherant(String email, String motDePasse) {
        // Vérifier si l'adhérant existe avec ces identifiants
        Optional<Adherant> adherantOpt = adherantRepository.findByEmail(email);
        
        if (!adherantOpt.isPresent()) {
            return "Identifiants incorrects.";
        }

        Adherant adherant = adherantOpt.get();

        // Vérifier le mot de passe
        if (!adherant.getMotDePasse().equals(motDePasse)) {
            return "Identifiants incorrects.";
        }

        // Vérifier que l'abonnement est valide
        if (!hasValidAbonnement(adherant)) {
            return "Votre abonnement n'est pas valide. Veuillez contacter la bibliothèque.";
        }

        return null; // Connexion réussie
    }

    /**
     * Vérifie si l'adhérant a un abonnement valide
     */
    private boolean hasValidAbonnement(Adherant adherant) {
        LocalDate dateActuelle = LocalDate.now();
        
        for (Abonnement abonnement : adherant.getAbonnements()) {
            if (!abonnement.getDateDebut().isAfter(dateActuelle) && 
                !abonnement.getDateFin().isBefore(dateActuelle)) {
                return true;
            }
        }
        
        return false;
    }

    /**
     * Trouve un adhérant par email
     */
    public Optional<Adherant> findAdherantByEmail(String email) {
        return adherantRepository.findByEmail(email);
    }
}