package com.example.biblio.repository;

import com.example.biblio.model.Exemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    @Query("SELECT e FROM Exemplaire e WHERE e.livre.id = :livreId AND e.statut = :statut")
    List<Exemplaire> findByLivreIdAndStatut(Integer livreId, Exemplaire.StatutExemplaire statut);
}