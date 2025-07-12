package com.example.biblio.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "JourFerier")
public class JourFerier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_jour_ferier")
    private Integer id;

    @Column(name = "date_ferier", nullable = false, unique = true)
    private LocalDate dateFerier;

    @Column(name = "description")
    private String description;

    public JourFerier() {}

    public JourFerier(LocalDate dateFerier, String description) {
        this.dateFerier = dateFerier;
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public LocalDate getDateFerier() {
        return dateFerier;
    }

    public void setDateFerier(LocalDate dateFerier) {
        this.dateFerier = dateFerier;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}