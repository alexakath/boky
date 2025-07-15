package com.example.biblio.controller;

import com.example.biblio.model.Livre;
import com.example.biblio.model.Exemplaire;
import com.example.biblio.service.LivreService;
import com.example.biblio.repository.ExemplaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/livres")
public class LivreRestController {

    @Autowired
    private LivreService livreService;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @GetMapping("/{id}")
    public ResponseEntity<LivreAvecExemplairesDTO> getLivreAvecExemplaires(@PathVariable("id") Integer id) {
        Optional<Livre> livreOpt = livreService.findLivreById(id);
        
        if (!livreOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        
        Livre livre = livreOpt.get();
        List<Exemplaire> exemplaires = exemplaireRepository.findByLivre(livre);
        
        LivreAvecExemplairesDTO dto = new LivreAvecExemplairesDTO(livre, exemplaires);
        
        return ResponseEntity.ok(dto);
    }

    // DTO pour la réponse JSON
    public static class LivreAvecExemplairesDTO {
        private Integer id;
        private String titre;
        private String auteur;
        private int ageMinimum;
        private String isbn;
        private List<ExemplaireDTO> exemplaires;
        private StatistiquesExemplairesDTO statistiques;

        public LivreAvecExemplairesDTO(Livre livre, List<Exemplaire> exemplaires) {
            this.id = livre.getId();
            this.titre = livre.getTitre();
            this.auteur = livre.getAuteur();
            this.ageMinimum = livre.getAgeMinimum();
            this.isbn = livre.getIsbn();
            
            this.exemplaires = exemplaires.stream()
                .map(ExemplaireDTO::new)
                .collect(Collectors.toList());
            
            this.statistiques = new StatistiquesExemplairesDTO(exemplaires);
        }

        // Getters
        public Integer getId() { return id; }
        public String getTitre() { return titre; }
        public String getAuteur() { return auteur; }
        public int getAgeMinimum() { return ageMinimum; }
        public String getIsbn() { return isbn; }
        public List<ExemplaireDTO> getExemplaires() { return exemplaires; }
        public StatistiquesExemplairesDTO getStatistiques() { return statistiques; }
    }

    // DTO pour les exemplaires
    public static class ExemplaireDTO {
        private Integer id;
        private String statut;

        public ExemplaireDTO(Exemplaire exemplaire) {
            this.id = exemplaire.getId();
            this.statut = exemplaire.getStatut().name();
        }

        // Getters
        public Integer getId() { return id; }
        public String getStatut() { return statut; }
    }

    // DTO pour les statistiques des exemplaires
    public static class StatistiquesExemplairesDTO {
        private int total;
        private int disponibles;
        private int empruntes;
        private int reserves;

        public StatistiquesExemplairesDTO(List<Exemplaire> exemplaires) {
            this.total = exemplaires.size();
            this.disponibles = (int) exemplaires.stream()
                .filter(e -> e.getStatut() == Exemplaire.StatutExemplaire.DISPONIBLE)
                .count();
            this.empruntes = (int) exemplaires.stream()
                .filter(e -> e.getStatut() == Exemplaire.StatutExemplaire.EMPRUNTE)
                .count();
            this.reserves = (int) exemplaires.stream()
                .filter(e -> e.getStatut() == Exemplaire.StatutExemplaire.RESERVE)
                .count();
        }

        // Getters
        public int getTotal() { return total; }
        public int getDisponibles() { return disponibles; }
        public int getEmpruntes() { return empruntes; }
        public int getReserves() { return reserves; }
    }
}