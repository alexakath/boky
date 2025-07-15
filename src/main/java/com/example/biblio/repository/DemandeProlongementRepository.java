package com.example.biblio.repository;

import com.example.biblio.model.DemandeProlongement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DemandeProlongementRepository extends JpaRepository<DemandeProlongement, Integer> {
    
    // Trouver les demandes de prolongement d'un adhérant
    @Query("SELECT d FROM DemandeProlongement d WHERE d.pret.adherant.id = ?1 ORDER BY d.dateDemande DESC")
    List<DemandeProlongement> findByAdherantId(Integer adherantId);
    
    // Trouver les demandes en attente
    @Query("SELECT d FROM DemandeProlongement d WHERE d.statut = 'EN_ATTENTE' ORDER BY d.dateDemande ASC")
    List<DemandeProlongement> findDemandesEnAttente();
    
    // Vérifier s'il existe déjà une demande en attente pour un prêt
    @Query("SELECT COUNT(d) FROM DemandeProlongement d WHERE d.pret.id = ?1 AND d.statut = 'EN_ATTENTE'")
    long countDemandesEnAttenteByPretId(Integer pretId);
}
