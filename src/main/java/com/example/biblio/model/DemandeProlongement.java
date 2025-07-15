package com.example.biblio.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "DemandeProlongement")
public class DemandeProlongement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_demande")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @Column(name = "nouvelle_date_retour", nullable = false)
    private LocalDate nouvelleDateRetour;

    @Column(name = "date_demande", nullable = false)
    private LocalDate dateDemande;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutDemande statut = StatutDemande.EN_ATTENTE;

    @Column(name = "motif_refus")
    private String motifRefus;

    public enum StatutDemande {
        EN_ATTENTE, ACCEPTEE, REFUSEE
    }

    public DemandeProlongement() {}

    public DemandeProlongement(Pret pret, LocalDate nouvelleDateRetour, LocalDate dateDemande) {
        this.pret = pret;
        this.nouvelleDateRetour = nouvelleDateRetour;
        this.dateDemande = dateDemande;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Pret getPret() {
        return pret;
    }

    public void setPret(Pret pret) {
        this.pret = pret;
    }

    public LocalDate getNouvelleDateRetour() {
        return nouvelleDateRetour;
    }

    public void setNouvelleDateRetour(LocalDate nouvelleDateRetour) {
        this.nouvelleDateRetour = nouvelleDateRetour;
    }

    public LocalDate getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(LocalDate dateDemande) {
        this.dateDemande = dateDemande;
    }

    public StatutDemande getStatut() {
        return statut;
    }

    public void setStatut(StatutDemande statut) {
        this.statut = statut;
    }

    public String getMotifRefus() {
        return motifRefus;
    }

    public void setMotifRefus(String motifRefus) {
        this.motifRefus = motifRefus;
    }
}