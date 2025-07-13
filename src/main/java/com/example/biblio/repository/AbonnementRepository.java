package com.example.biblio.repository;

import com.example.biblio.model.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    
    /**
     * Trouve tous les abonnements d'un adhérant
     */
    List<Abonnement> findByAdherantIdOrderByDateFinDesc(Integer adherantId);
    
    /**
     * Trouve l'abonnement le plus récent d'un adhérant
     */
    @Query("SELECT a FROM Abonnement a WHERE a.adherant.id = :adherantId ORDER BY a.dateFin DESC LIMIT 1")
    Optional<Abonnement> findLatestByAdherantId(@Param("adherantId") Integer adherantId);
    
    /**
     * Vérifie s'il existe un abonnement qui se chevauche avec les dates données
     */
    @Query("SELECT COUNT(a) FROM Abonnement a WHERE a.adherant.id = :adherantId " +
           "AND ((a.dateDebut <= :dateDebut AND a.dateFin >= :dateDebut) " +
           "OR (a.dateDebut <= :dateFin AND a.dateFin >= :dateFin) " +
           "OR (a.dateDebut >= :dateDebut AND a.dateFin <= :dateFin))")
    Long countOverlappingAbonnements(@Param("adherantId") Integer adherantId, 
                                    @Param("dateDebut") LocalDate dateDebut, 
                                    @Param("dateFin") LocalDate dateFin);
    
    /**
     * Trouve les abonnements actifs d'un adhérant
     */
    @Query("SELECT a FROM Abonnement a WHERE a.adherant.id = :adherantId " +
           "AND a.dateDebut <= :currentDate AND a.dateFin >= :currentDate")
    List<Abonnement> findActiveAbonnementsByAdherantId(@Param("adherantId") Integer adherantId, 
                                                       @Param("currentDate") LocalDate currentDate);
}