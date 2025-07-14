package com.example.biblio.controller;

import com.example.biblio.model.Pret;
import com.example.biblio.service.RetourService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
@RequestMapping("/retours")
public class RetourController {

    @Autowired
    private RetourService retourService;

    @GetMapping("/rendre")
    public String showRendreLivre(Model model) {
        List<Pret> pretsActifs = retourService.findAllPretsActifs();
        model.addAttribute("pretsActifs", pretsActifs);
        return "biblio/rendreLivre";
    }

    @PostMapping("/rendre")
    public String rendreLivre(
            @RequestParam("idAdherant") Integer idAdherant,
            @RequestParam("idExemplaire") Integer idExemplaire,
            @RequestParam("dateRetourReelle") String dateRetourReelle,
            Model model) {

        try {
            LocalDate dateRetour = LocalDate.parse(dateRetourReelle);
            
            // Le nombre de jours de pénalité est maintenant fixe selon le type d'adhérant
            String error = retourService.rendreLivre(idAdherant, idExemplaire, dateRetour, null);

            if (error != null) {
                model.addAttribute("error", error);
                model.addAttribute("idAdherant", idAdherant);
                model.addAttribute("idExemplaire", idExemplaire);
                model.addAttribute("dateRetourReelle", dateRetourReelle);
            } else {
                model.addAttribute("success", "Livre rendu avec succès.");
            }
        } catch (DateTimeParseException e) {
            model.addAttribute("error", "Format de date invalide. Utilisez le format YYYY-MM-DD.");
            model.addAttribute("idAdherant", idAdherant);
            model.addAttribute("idExemplaire", idExemplaire);
            model.addAttribute("dateRetourReelle", dateRetourReelle);
        }

        List<Pret> pretsActifs = retourService.findAllPretsActifs();
        model.addAttribute("pretsActifs", pretsActifs);
        return "biblio/rendreLivre";
    }
}