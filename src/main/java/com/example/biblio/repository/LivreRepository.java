package com.example.biblio.repository;

import com.example.biblio.model.Livre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LivreRepository extends JpaRepository<Livre, Integer> {
    
    // Recherche par titre (insensible à la casse)
    List<Livre> findByTitreContainingIgnoreCase(String titre);
    
    // Recherche par ISBN
    Optional<Livre> findByIsbn(String isbn);
    
    // Recherche par auteur
    List<Livre> findByAuteurContainingIgnoreCase(String auteur);
    
    // Recherche par titre et auteur
    List<Livre> findByTitreContainingIgnoreCaseAndAuteurContainingIgnoreCase(String titre, String auteur);
}