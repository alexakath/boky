package com.example.biblio.service;

import com.example.biblio.model.JourFerier;
import com.example.biblio.repository.JourFerierRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class JourFerierService {

    @Autowired
    private JourFerierRepository jourFerierRepository;

    public List<JourFerier> findAllJoursFeries() {
        return jourFerierRepository.findAllByOrderByDateFerierAsc();
    }

    public List<JourFerier> findJoursFeriesAVenir() {
        return jourFerierRepository.findByDateFerierGreaterThanEqualOrderByDateFerierAsc(LocalDate.now());
    }

    public String ajouterJourFerier(LocalDate dateFerier, String description) {
        // Validation des paramètres
        if (dateFerier == null) {
            return "La date du jour férié est obligatoire.";
        }

        if (description == null || description.trim().isEmpty()) {
            return "La description du jour férié est obligatoire.";
        }

        // Vérifier que la date n'est pas antérieure à aujourd'hui
        if (dateFerier.isBefore(LocalDate.now())) {
            return "La date du jour férié ne peut pas être antérieure à la date actuelle.";
        }

        // Vérifier que la date n'existe pas déjà
        if (jourFerierRepository.existsByDateFerier(dateFerier)) {
            return "Cette date est déjà enregistrée comme jour férié.";
        }

        // Créer et enregistrer le jour férié
        JourFerier jourFerier = new JourFerier(dateFerier, description.trim());
        jourFerierRepository.save(jourFerier);

        return null; // Pas d'erreur
    }

    public boolean supprimerJourFerier(Integer id) {
        if (id != null && jourFerierRepository.existsById(id)) {
            jourFerierRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public boolean isJourFerier(LocalDate date) {
        return jourFerierRepository.existsByDateFerier(date);
    }
}