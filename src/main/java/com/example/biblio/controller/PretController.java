package com.example.biblio.controller;

import com.example.biblio.service.PretService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/prets")
public class PretController {

    @Autowired
    private PretService pretService;

    @GetMapping("/preter")
    public String showPreterLivre(Model model) {
        model.addAttribute("adherants", pretService.findAllAdherants());
        model.addAttribute("exemplaires", pretService.findAllExemplairesDisponibles());
        return "biblio/preterLivre";
    }

    @PostMapping("/preter")
    public String preterLivre(
            @RequestParam("adherantId") Integer adherantId,
            @RequestParam("exemplaireId") Integer exemplaireId,
            @RequestParam("typePret") String typePret,
            Model model) {

        String error = pretService.preterLivre(adherantId, exemplaireId, typePret);

        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("adherants", pretService.findAllAdherants());
            model.addAttribute("exemplaires", pretService.findAllExemplairesDisponibles());
            return "biblio/preterLivre";
        }

        model.addAttribute("success", "Le livre a été prêté avec succès!");
        model.addAttribute("adherants", pretService.findAllAdherants());
        model.addAttribute("exemplaires", pretService.findAllExemplairesDisponibles());
        return "biblio/preterLivre";
    }
}