package com.example.biblio.service;

import com.example.biblio.model.Penalite;
import com.example.biblio.repository.PenaliteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class PenaliteService {

    @Autowired
    private PenaliteRepository penaliteRepository;

    public List<Penalite> findAllPenalitesActives() {
        return penaliteRepository.findPenalitesActives(LocalDate.now());
    }

    public String supprimerPenalite(Integer id) {
        if (id == null) {
            return "ID de pénalité invalide.";
        }

        Optional<Penalite> penaliteOpt = penaliteRepository.findById(id);
        if (!penaliteOpt.isPresent()) {
            return "Pénalité non trouvée.";
        }

        try {
            penaliteRepository.deleteById(id);
            return null; // Pas d'erreur
        } catch (Exception e) {
            return "Erreur lors de la suppression de la pénalité.";
        }
    }

    public int supprimerPenalitesExpirees() {
        List<Penalite> penalitesExpirees = penaliteRepository.findPenalitesExpirees(LocalDate.now());
        int nombreSupprimees = penalitesExpirees.size();
        
        for (Penalite penalite : penalitesExpirees) {
            penaliteRepository.deleteById(penalite.getId());
        }
        
        return nombreSupprimees;
    }
}