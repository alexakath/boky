package com.example.biblio.repository;

import com.example.biblio.model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    
    // Trouver les réservations en attente pour un exemplaire spécifique, ordonnées par date
    @Query("SELECT r FROM Reservation r WHERE r.exemplaire.id = :exemplaireId AND r.statut = :statut ORDER BY r.dateReservation ASC")
    List<Reservation> findByExemplaireIdAndStatutOrderByDateReservationAsc(Integer exemplaireId, Reservation.StatutReservation statut);
}