package com.example.biblio.controller;

import com.example.biblio.model.Abonnement;
import com.example.biblio.model.Adherant;
import com.example.biblio.service.AbonnementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Controller
@RequestMapping("/abonnements")
public class AbonnementController {

    @Autowired
    private AbonnementService abonnementService;

    @GetMapping("/renouveler")
    public String showRenouvelerAbonnement(Model model) {
        model.addAttribute("adherants", abonnementService.findAllAdherants());
        return "biblio/renouveler-abonnement";
    }

    @PostMapping("/renouveler")
    public String renouvelerAbonnement(
            @RequestParam("adherantId") Integer adherantId,
            @RequestParam("nouvelleDateFin") String nouvelleDateFin,
            Model model) {

        try {
            LocalDate dateFin = LocalDate.parse(nouvelleDateFin);
            String error = abonnementService.renouvelerAbonnement(adherantId, dateFin);

            if (error != null) {
                model.addAttribute("error", error);
                model.addAttribute("adherants", abonnementService.findAllAdherants());
                model.addAttribute("adherantId", adherantId);
                model.addAttribute("nouvelleDateFin", nouvelleDateFin);
                return "biblio/renouveler-abonnement";
            }

            // Obtenir les détails de l'adhérant pour le message de succès
            Optional<Adherant> adherantOpt = abonnementService.findAdherantById(adherantId);
            String nomComplet = adherantOpt.map(a -> a.getPrenom() + " " + a.getNom()).orElse("Adhérant #" + adherantId);
            
            model.addAttribute("success", 
                String.format("L'abonnement de %s a été renouvelé avec succès jusqu'au %s.", 
                    nomComplet, dateFin.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))));
            model.addAttribute("adherants", abonnementService.findAllAdherants());
            
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du renouvellement : " + e.getMessage());
            model.addAttribute("adherants", abonnementService.findAllAdherants());
            model.addAttribute("adherantId", adherantId);
            model.addAttribute("nouvelleDateFin", nouvelleDateFin);
        }

        return "biblio/renouveler-abonnement";
    }

    @GetMapping("/details/{id}")
    @ResponseBody
    public String getAdherantDetails(@PathVariable("id") Integer id) {
        Optional<Adherant> adherantOpt = abonnementService.findAdherantById(id);
        if (!adherantOpt.isPresent()) {
            return "Adhérant non trouvé";
        }

        Adherant adherant = adherantOpt.get();
        
        // Utiliser la nouvelle méthode du service
        Optional<Abonnement> abonnementActuelOpt = abonnementService.getAbonnementActuel(id);
        
        if (abonnementActuelOpt.isPresent()) {
            Abonnement abonnementActuel = abonnementActuelOpt.get();
            boolean estActif = abonnementService.isAbonnementActif(abonnementActuel);
            String statut = estActif ? "Actif" : "Expiré";
            String couleur = estActif ? "text-success" : "text-danger";
            
            return String.format(
                "<strong>%s %s</strong><br>" +
                "Type: %s<br>" +
                "Abonnement actuel: du %s au %s<br>" +
                "<span class='%s'>Statut: %s</span><br>" +
                "Prochaine date de début: %s", 
                adherant.getPrenom(), 
                adherant.getNom(),
                adherant.getTypeAdherant().getNomType(),
                abonnementActuel.getDateDebut().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                abonnementActuel.getDateFin().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                couleur,
                statut,
                abonnementActuel.getDateFin().plusDays(1).format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
            );
        } else {
            return String.format(
                "<strong>%s %s</strong><br>" +
                "Type: %s<br>" +
                "<span class='text-warning'>Aucun abonnement actuel</span><br>" +
                "Prochaine date de début: %s", 
                adherant.getPrenom(), 
                adherant.getNom(),
                adherant.getTypeAdherant().getNomType(),
                LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
            );
        }
    }
}