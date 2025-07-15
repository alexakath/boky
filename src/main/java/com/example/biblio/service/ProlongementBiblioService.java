package com.example.biblio.service;

import com.example.biblio.model.DemandeProlongement;
import com.example.biblio.model.Pret;
import com.example.biblio.model.Adherant;
import com.example.biblio.repository.DemandeProlongementRepository;
import com.example.biblio.repository.PretRepository;
import com.example.biblio.repository.AdherantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProlongementBiblioService {

    @Autowired
    private DemandeProlongementRepository demandeProlongementRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AdherantRepository adherantRepository;

    public List<DemandeProlongement> getDemandesEnAttente() {
        return demandeProlongementRepository.findDemandesEnAttente();
    }

    public String validerDemande(Integer idDemande) {
        try {
            Optional<DemandeProlongement> demandeOpt = demandeProlongementRepository.findById(idDemande);
            
            if (!demandeOpt.isPresent()) {
                return "Erreur : Demande non trouvée";
            }

            DemandeProlongement demande = demandeOpt.get();
            
            if (demande.getStatut() != DemandeProlongement.StatutDemande.EN_ATTENTE) {
                return "Erreur : Cette demande a déjà été traitée";
            }

            // Mettre à jour le prêt avec la nouvelle date de retour
            Pret pret = demande.getPret();
            pret.setDateRetourPrevue(demande.getNouvelleDateRetour());
            pret.setNombreProlongements(pret.getNombreProlongements() + 1);

            // Décrémenter le quota de prolongements de l'adhérant
            Adherant adherant = pret.getAdherant();
            adherant.setQuotaRestantProlog(adherant.getQuotaRestantProlog() - 1);

            // Marquer la demande comme acceptée
            demande.setStatut(DemandeProlongement.StatutDemande.ACCEPTEE);

            // Sauvegarder les modifications
            pretRepository.save(pret);
            adherantRepository.save(adherant);
            demandeProlongementRepository.save(demande);

            return "Demande validée avec succès";

        } catch (Exception e) {
            return "Erreur lors du prolongement d'un livre : " + e.getMessage();
        }
    }

    public String rejeterDemande(Integer idDemande, String motifRefus) {
        try {
            Optional<DemandeProlongement> demandeOpt = demandeProlongementRepository.findById(idDemande);
            
            if (!demandeOpt.isPresent()) {
                return "Erreur : Demande non trouvée";
            }

            DemandeProlongement demande = demandeOpt.get();
            
            if (demande.getStatut() != DemandeProlongement.StatutDemande.EN_ATTENTE) {
                return "Erreur : Cette demande a déjà été traitée";
            }

            // Marquer la demande comme refusée
            demande.setStatut(DemandeProlongement.StatutDemande.REFUSEE);
            demande.setMotifRefus(motifRefus);

            // Sauvegarder les modifications
            demandeProlongementRepository.save(demande);

            return "Demande rejetée avec succès";

        } catch (Exception e) {
            return "Erreur lors du rejet de la demande : " + e.getMessage();
        }
    }
}
