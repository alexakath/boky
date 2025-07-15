package com.example.biblio.controller;

import com.example.biblio.model.Adherant;
import com.example.biblio.service.AdherantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/adherants")
public class AdherantRestController {

    @Autowired
    private AdherantService adherantService;

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getAdherantById(@PathVariable("id") Integer id) {
        Optional<Adherant> adherantOpt = adherantService.findAdherantById(id);
        
        if (!adherantOpt.isPresent()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Adhérant non trouvé");
            errorResponse.put("message", "Aucun adhérant trouvé avec l'ID: " + id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
        }

        Adherant adherant = adherantOpt.get();
        Map<String, Object> response = new HashMap<>();
        
        // Informations de base de l'adhérant
        response.put("id", adherant.getId());
        response.put("nom", adherant.getNom());
        response.put("prenom", adherant.getPrenom());
        response.put("dateNaissance", adherant.getDateNaissance());
        response.put("email", adherant.getEmail());
        
        // Informations sur le type d'adhérant
        Map<String, Object> typeAdherant = new HashMap<>();
        typeAdherant.put("id", adherant.getTypeAdherant().getId());
        typeAdherant.put("nom", adherant.getTypeAdherant().getNomType());
        typeAdherant.put("quotaEmprunts", adherant.getTypeAdherant().getQuotaEmprunts());
        typeAdherant.put("quotaReservations", adherant.getTypeAdherant().getQuotaReservations());
        typeAdherant.put("quotaProlongements", adherant.getTypeAdherant().getQuotaProlongements());
        typeAdherant.put("joursPenalite", adherant.getTypeAdherant().getJoursPenalite());
        response.put("typeAdherant", typeAdherant);
        
        // Quotas restants
        Map<String, Object> quotasRestants = new HashMap<>();
        quotasRestants.put("emprunt", adherant.getQuotaRestantEmprunt());
        quotasRestants.put("reservation", adherant.getQuotaRestantResa());
        quotasRestants.put("prolongement", adherant.getQuotaRestantProlog());
        response.put("quotasRestants", quotasRestants);
        
        // Statistiques
        Map<String, Object> statistiques = new HashMap<>();
        statistiques.put("nombreAbonnements", adherant.getAbonnements().size());
        statistiques.put("nombrePrets", adherant.getPrets().size());
        statistiques.put("nombreReservations", adherant.getReservations().size());
        statistiques.put("nombrePenalites", adherant.getPenalites().size());
        response.put("statistiques", statistiques);
        
        // Abonnement actuel (le plus récent)
        if (!adherant.getAbonnements().isEmpty()) {
            // Trouver l'abonnement le plus récent
            adherant.getAbonnements().stream()
                .max((a1, a2) -> a1.getDateDebut().compareTo(a2.getDateDebut()))
                .ifPresent(abonnement -> {
                    Map<String, Object> abonnementInfo = new HashMap<>();
                    abonnementInfo.put("id", abonnement.getId());
                    abonnementInfo.put("dateDebut", abonnement.getDateDebut());
                    abonnementInfo.put("dateFin", abonnement.getDateFin());
                    abonnementInfo.put("actif", abonnement.getDateFin().isAfter(java.time.LocalDate.now()));
                    response.put("abonnementActuel", abonnementInfo);
                });
        }
        
        return ResponseEntity.ok(response);
    }
}