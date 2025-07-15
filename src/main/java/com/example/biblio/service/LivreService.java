package com.example.biblio.service;

import com.example.biblio.model.Livre;
import com.example.biblio.model.Exemplaire;
import com.example.biblio.repository.LivreRepository;
import com.example.biblio.repository.ExemplaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class LivreService {

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    public List<Livre> findAllLivres() {
        return livreRepository.findAll();
    }

    public List<Livre> findLivresByTitre(String titre) {
        return livreRepository.findByTitreContainingIgnoreCase(titre);
    }

    public Optional<Livre> findLivreById(Integer id) {
        return livreRepository.findById(id);
    }

    @Transactional
    public String ajouterLivre(String titre, String auteur, int ageMinimum, String isbn, int nombreExemplaires) {
        // Validation des paramètres
        if (titre == null || titre.trim().isEmpty()) {
            return "Le titre du livre est obligatoire.";
        }
        
        if (auteur == null || auteur.trim().isEmpty()) {
            return "L'auteur du livre est obligatoire.";
        }
        
        if (ageMinimum < 0) {
            return "L'âge minimum ne peut pas être négatif.";
        }
        
        if (isbn != null && !isbn.trim().isEmpty()) {
            // Vérification de l'unicité de l'ISBN
            Optional<Livre> existingLivre = livreRepository.findByIsbn(isbn);
            if (existingLivre.isPresent()) {
                return "Un livre avec cet ISBN existe déjà.";
            }
        }
        
        if (nombreExemplaires <= 0) {
            return "Le nombre d'exemplaires doit être supérieur à 0.";
        }

        // Création du livre
        Livre livre = new Livre(titre.trim(), auteur.trim(), ageMinimum, isbn != null ? isbn.trim() : null);
        livre = livreRepository.save(livre);

        // Création des exemplaires
        for (int i = 0; i < nombreExemplaires; i++) {
            Exemplaire exemplaire = new Exemplaire(livre, Exemplaire.StatutExemplaire.DISPONIBLE);
            exemplaireRepository.save(exemplaire);
        }

        return null; // Pas d'erreur
    }

    @Transactional
    public String supprimerLivre(Integer id) {
        Optional<Livre> livreOpt = livreRepository.findById(id);
        if (!livreOpt.isPresent()) {
            return "Livre inexistant dans la base.";
        }

        Livre livre = livreOpt.get();
        
        // Vérifier si des exemplaires sont empruntés ou réservés
        List<Exemplaire> exemplaires = exemplaireRepository.findByLivre(livre);
        for (Exemplaire exemplaire : exemplaires) {
            if (exemplaire.getStatut() == Exemplaire.StatutExemplaire.EMPRUNTE ||
                exemplaire.getStatut() == Exemplaire.StatutExemplaire.RESERVE) {
                return "Impossible de supprimer le livre. Certains exemplaires sont empruntés ou réservés.";
            }
        }

        // Supprimer le livre (les exemplaires seront supprimés automatiquement par CASCADE)
        livreRepository.delete(livre);
        return null; // Pas d'erreur
    }
}