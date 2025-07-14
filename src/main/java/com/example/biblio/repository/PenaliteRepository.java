package com.example.biblio.repository;

import com.example.biblio.model.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    List<Penalite> findByAdherantIdAndDateFinPenaliteAfter(Integer adherantId, LocalDate date);
    
    // Récupérer toutes les pénalités actives (non expirées)
    @Query("SELECT p FROM Penalite p WHERE p.dateFinPenalite > ?1 ORDER BY p.dateDebutPenalite DESC")
    List<Penalite> findPenalitesActives(LocalDate dateActuelle);
    
    // Récupérer toutes les pénalités expirées
    @Query("SELECT p FROM Penalite p WHERE p.dateFinPenalite <= ?1")
    List<Penalite> findPenalitesExpirees(LocalDate dateActuelle);
}