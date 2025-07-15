package com.example.biblio.repository;

import com.example.biblio.model.Exemplaire;
import com.example.biblio.model.Livre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExemplaireRepository extends JpaRepository<Exemplaire, Integer> {
    
    // Trouver tous les exemplaires d'un livre
    List<Exemplaire> findByLivre(Livre livre);
    
    // Trouver les exemplaires disponibles d'un livre
    List<Exemplaire> findByLivreAndStatut(Livre livre, Exemplaire.StatutExemplaire statut);
    
    // Compter le nombre d'exemplaires par statut pour un livre
    @Query("SELECT COUNT(e) FROM Exemplaire e WHERE e.livre = ?1 AND e.statut = ?2")
    long countByLivreAndStatut(Livre livre, Exemplaire.StatutExemplaire statut);
    
    // Compter le nombre total d'exemplaires d'un livre
    @Query("SELECT COUNT(e) FROM Exemplaire e WHERE e.livre = ?1")
    long countByLivre(Livre livre);
}