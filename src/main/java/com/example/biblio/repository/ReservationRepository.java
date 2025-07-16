package com.example.biblio.repository;

import com.example.biblio.model.DemandeReservation;
import com.example.biblio.model.Reservation;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<DemandeReservation, Integer> {
    
    // Trouver les demandes de réservation par adhérant
    List<DemandeReservation> findByAdherantIdOrderByDateDemandeDesc(Integer adherantId);
    
    // Trouver les demandes en attente pour un exemplaire spécifique
    List<DemandeReservation> findByExemplaireIdAndStatutOrderByDateDemandeAsc(Integer exemplaireId, DemandeReservation.StatutDemandeReservation statut);
    
    // Compter les demandes en attente pour un adhérant
    @Query("SELECT COUNT(d) FROM DemandeReservation d WHERE d.adherant.id = :adherantId AND d.statut = :statut")
    long countByAdherantIdAndStatut(Integer adherantId, DemandeReservation.StatutDemandeReservation statut);
    
    // Trouver toutes les demandes en attente (pour le bibliothécaire)
    List<DemandeReservation> findByStatutOrderByDateDemandeAsc(DemandeReservation.StatutDemandeReservation statut);

    // Trouver les réservations en attente pour un exemplaire spécifique, ordonnées par date
    @Query("SELECT r FROM Reservation r WHERE r.exemplaire.id = :exemplaireId AND r.statut = :statut ORDER BY r.dateReservation ASC")
    List<Reservation> findByExemplaireIdAndStatutOrderByDateReservationAsc(Integer exemplaireId, Reservation.StatutReservation statut);

    void save(Reservation premiereReservation);
}