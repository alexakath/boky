package com.example.biblio.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "DemandeReservation")
public class DemandeReservation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_demande_reservation")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_adherant", nullable = false)
    private Adherant adherant;

    @Column(name = "date_demande", nullable = false)
    private LocalDate dateDemande;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutDemandeReservation statut = StatutDemandeReservation.EN_ATTENTE;

    @Column(name = "motif_refus")
    private String motifRefus;

    @Column(name = "date_validation")
    private LocalDate dateValidation;

    public enum StatutDemandeReservation {
        EN_ATTENTE, ACCEPTEE, REFUSEE, ANNULEE
    }

    public DemandeReservation() {}

    public DemandeReservation(Exemplaire exemplaire, Adherant adherant, LocalDate dateDemande) {
        this.exemplaire = exemplaire;
        this.adherant = adherant;
        this.dateDemande = dateDemande;
        this.statut = StatutDemandeReservation.EN_ATTENTE;
    }

    // Getters et Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public Adherant getAdherant() {
        return adherant;
    }

    public void setAdherant(Adherant adherant) {
        this.adherant = adherant;
    }

    public LocalDate getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(LocalDate dateDemande) {
        this.dateDemande = dateDemande;
    }

    public StatutDemandeReservation getStatut() {
        return statut;
    }

    public void setStatut(StatutDemandeReservation statut) {
        this.statut = statut;
    }

    public String getMotifRefus() {
        return motifRefus;
    }

    public void setMotifRefus(String motifRefus) {
        this.motifRefus = motifRefus;
    }

    public LocalDate getDateValidation() {
        return dateValidation;
    }

    public void setDateValidation(LocalDate dateValidation) {
        this.dateValidation = dateValidation;
    }
}
