package com.example.biblio.repository;

import com.example.biblio.model.JourFerier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface JourFerierRepository extends JpaRepository<JourFerier, Integer> {
    
    // Vérifier si une date existe déjà
    boolean existsByDateFerier(LocalDate dateFerier);
    
    // Récupérer tous les jours fériés ordonnés par date
    List<JourFerier> findAllByOrderByDateFerierAsc();
    
    // Récupérer les jours fériés à partir d'une date donnée
    List<JourFerier> findByDateFerierGreaterThanEqualOrderByDateFerierAsc(LocalDate date);
}
