package com.example.biblio.controller;

import com.example.biblio.model.Pret;
import com.example.biblio.service.PretService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/prets")
public class PretController {

    @Autowired
    private PretService pretService;

    @GetMapping("/preter")
    public String showPreterLivre(Model model) {
        List<Pret> pretsActifs = pretService.findAllPretsActifs();
        model.addAttribute("pretsActifs", pretsActifs);
        return "biblio/preterLivre";
    }

    @PostMapping("/preter")
    public String preterLivre(
            @RequestParam("idAdherant") Integer idAdherant,
            @RequestParam("idExemplaire") Integer idExemplaire,
            @RequestParam("typePret") String typePret,
            Model model) {

        String error = pretService.preterLivre(idAdherant, idExemplaire, typePret);

        if (error != null) {
            model.addAttribute("error", error);
            List<Pret> pretsActifs = pretService.findAllPretsActifs();
            model.addAttribute("pretsActifs", pretsActifs);
            return "biblio/preterLivre";
        }

        return "redirect:/prets/preter";
    }
}
