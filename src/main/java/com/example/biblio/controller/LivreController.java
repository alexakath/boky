package com.example.biblio.controller;

import com.example.biblio.model.Livre;
import com.example.biblio.service.LivreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/livres")
public class LivreController {

    @Autowired
    private LivreService livreService;

    @GetMapping("/lister")
    public String listerLivres(Model model) {
        List<Livre> livres = livreService.findAllLivres();
        model.addAttribute("livres", livres);
        return "biblio/listeLivres";
    }

    @GetMapping("/rechercher")
    public String rechercherLivres(@RequestParam(value = "titre", required = false) String titre, Model model) {
        List<Livre> livres;
        
        if (titre != null && !titre.trim().isEmpty()) {
            livres = livreService.findLivresByTitre(titre);
            model.addAttribute("titreRecherche", titre);
        } else {
            livres = livreService.findAllLivres();
        }
        
        model.addAttribute("livres", livres);
        return "biblio/listeLivres";
    }

    @PostMapping("/ajouter")
    public String ajouterLivre(
            @RequestParam("titre") String titre,
            @RequestParam("auteur") String auteur,
            @RequestParam("ageMinimum") int ageMinimum,
            @RequestParam("isbn") String isbn,
            @RequestParam("nombreExemplaires") int nombreExemplaires,
            Model model) {

        String error = livreService.ajouterLivre(titre, auteur, ageMinimum, isbn, nombreExemplaires);
        
        if (error != null) {
            model.addAttribute("error", error);
            List<Livre> livres = livreService.findAllLivres();
            model.addAttribute("livres", livres);
            return "biblio/listeLivres";
        }
        
        return "redirect:/livres/lister";
    }

    @PostMapping("/supprimer/{id}")
    public String supprimerLivre(@PathVariable("id") Integer id, Model model) {
        String error = livreService.supprimerLivre(id);
        
        if (error != null) {
            model.addAttribute("error", error);
            List<Livre> livres = livreService.findAllLivres();
            model.addAttribute("livres", livres);
            return "biblio/listeLivres";
        }
        
        return "redirect:/livres/lister";
    }
}