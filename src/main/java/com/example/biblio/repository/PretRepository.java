package com.example.biblio.repository;

import com.example.biblio.model.Pret;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PretRepository extends JpaRepository<Pret, Integer> {
    
    // Récupère tous les prêts actifs (non retournés)
    @Query("SELECT p FROM Pret p WHERE p.dateRetourReelle IS NULL ORDER BY p.datePret DESC")
    List<Pret> findPretsActifs();
    
    // Récupère les prêts actifs d'un adhérant spécifique
    @Query("SELECT p FROM Pret p WHERE p.adherant.id = ?1 AND p.dateRetourReelle IS NULL ORDER BY p.datePret DESC")
    List<Pret> findPretsActifsByAdherant(Integer adherantId);
}