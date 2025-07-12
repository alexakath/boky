package com.example.biblio.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Adherant")
public class Adherant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_adherant")
    private Integer id;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "prenom", nullable = false)
    private String prenom;

    @Column(name = "date_naissance", nullable = false)
    private LocalDate dateNaissance;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @ManyToOne
    @JoinColumn(name = "id_type_adherant", nullable = false)
    private TypeAdherant typeAdherant;

    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;

    @Column(name = "quota_restant_emprunt", nullable = false)
    private int quotaRestantEmprunt = 0;

    @Column(name = "quota_restant_resa", nullable = false)
    private int quotaRestantResa = 0;

    @Column(name = "quota_restant_prolog", nullable = false)
    private int quotaRestantProlog = 0;

    @OneToMany(mappedBy = "adherant", cascade = CascadeType.ALL)
    private Set<Abonnement> abonnements = new HashSet<>();

    @OneToMany(mappedBy = "adherant")
    private Set<Pret> prets = new HashSet<>();

    @OneToMany(mappedBy = "adherant")
    private Set<Reservation> reservations = new HashSet<>();

    @OneToMany(mappedBy = "adherant")
    private Set<Penalite> penalites = new HashSet<>();

    public Adherant() {}

    public Adherant(String nom, String prenom, LocalDate dateNaissance, String email,
                    TypeAdherant typeAdherant, String motDePasse) {
        this.nom = nom;
        this.prenom = prenom;
        this.dateNaissance = dateNaissance;
        this.email = email;
        this.typeAdherant = typeAdherant;
        this.motDePasse = motDePasse;
        // quota_restant sera initialisé via AdherantService
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public LocalDate getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(LocalDate dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public TypeAdherant getTypeAdherant() {
        return typeAdherant;
    }

    public void setTypeAdherant(TypeAdherant typeAdherant) {
        this.typeAdherant = typeAdherant;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public int getQuotaRestantEmprunt() {
    return quotaRestantEmprunt;
    }

    public void setQuotaRestantEmprunt(int quotaRestantEmprunt) {
        this.quotaRestantEmprunt = quotaRestantEmprunt;
    }

    public int getQuotaRestantResa() {
        return quotaRestantResa;
    }

    public void setQuotaRestantResa(int quotaRestantResa) {
        this.quotaRestantResa = quotaRestantResa;
    }

    public int getQuotaRestantProlog() {
        return quotaRestantProlog;
    }

    public void setQuotaRestantProlog(int quotaRestantProlog) {
        this.quotaRestantProlog = quotaRestantProlog;
    }
    
    public Set<Abonnement> getAbonnements() {
        return abonnements;
    }

    public void setAbonnements(Set<Abonnement> abonnements) {
        this.abonnements = abonnements;
    }

    public Set<Pret> getPrets() {
        return prets;
    }

    public void setPrets(Set<Pret> prets) {
        this.prets = prets;
    }

    public Set<Reservation> getReservations() {
        return reservations;
    }

    public void setReservations(Set<Reservation> reservations) {
        this.reservations = reservations;
    }

    public Set<Penalite> getPenalites() {
        return penalites;
    }

    public void setPenalites(Set<Penalite> penalites) {
        this.penalites = penalites;
    }
}