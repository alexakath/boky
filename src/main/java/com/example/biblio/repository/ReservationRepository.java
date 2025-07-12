package com.example.biblio.repository;

import com.example.biblio.model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    
    // Trouver les réservations en attente pour un exemplaire donné
    @Query("SELECT r FROM Reservation r WHERE r.exemplaire.id = :exemplaireId AND r.statut = 'EN_ATTENTE'")
    List<Reservation> findByExemplaireIdAndStatutEnAttente(Integer exemplaireId);
    
    // Trouver les réservations d'un adhérant avec un statut donné
    @Query("SELECT r FROM Reservation r WHERE r.adherant.id = :adherantId AND r.statut = :statut")
    List<Reservation> findByAdherantIdAndStatut(Integer adherantId, Reservation.StatutReservation statut);
    
    // Compter les réservations en attente d'un adhérant
    @Query("SELECT COUNT(r) FROM Reservation r WHERE r.adherant.id = :adherantId AND r.statut = 'EN_ATTENTE'")
    long countByAdherantIdAndStatutEnAttente(Integer adherantId);
}
