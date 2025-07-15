package com.example.biblio.controller;

import com.example.biblio.model.DemandeProlongement;
import com.example.biblio.service.ProlongementBiblioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/prolongements")
public class ProlongementBiblioController {

    @Autowired
    private ProlongementBiblioService prolongementBiblioService;

    @GetMapping("/gerer")
    public String gererProlongements(Model model) {
        List<DemandeProlongement> demandesEnAttente = prolongementBiblioService.getDemandesEnAttente();
        model.addAttribute("demandesEnAttente", demandesEnAttente);
        return "biblio/prolongementBiblio";
    }

    @PostMapping("/valider")
    public String validerDemande(@RequestParam("idDemande") Integer idDemande, Model model) {
        String message = prolongementBiblioService.validerDemande(idDemande);
        
        if (message.startsWith("Erreur")) {
            model.addAttribute("error", message);
        } else {
            model.addAttribute("success", message);
        }
        
        // Recharger la liste des demandes
        List<DemandeProlongement> demandesEnAttente = prolongementBiblioService.getDemandesEnAttente();
        model.addAttribute("demandesEnAttente", demandesEnAttente);
        
        return "biblio/prolongementBiblio";
    }

    @PostMapping("/rejeter")
    public String rejeterDemande(
            @RequestParam("idDemande") Integer idDemande,
            @RequestParam("motifRefus") String motifRefus,
            Model model) {
        
        String message = prolongementBiblioService.rejeterDemande(idDemande, motifRefus);
        
        if (message.startsWith("Erreur")) {
            model.addAttribute("error", message);
        } else {
            model.addAttribute("success", message);
        }
        
        // Recharger la liste des demandes
        List<DemandeProlongement> demandesEnAttente = prolongementBiblioService.getDemandesEnAttente();
        model.addAttribute("demandesEnAttente", demandesEnAttente);
        
        return "biblio/prolongementBiblio";
    }
}