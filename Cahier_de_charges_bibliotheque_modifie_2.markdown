Cahier des charges - Système de gestion de bibliothèque (Version modifiée 3)
1. Prêter un livre

Nom: Prêter_livre (CHECK)
Objectifs: Permettre à un adhérant d'emprunter un exemplaire d'un livre (lecture sur place ou à emporter).
Acteur: Bibliothécaire
Entrée:
Référence du livre (id_livre dans la table exemplaire)
Référence de l'adhérant
Type de prêt (lecture sur place ou à emporter)
Date actuelle

Scénario nominal:
Le bibliothécaire se connecte au système.
Il accède au menu "Gestion des Prêts".
Il entre la référence de l'adhérant, la référence du livre (id_livre dans a table exemplaire) et le type de prêt.
Verification de la validité de l'abonnement, du nbr de quota, l'absence de penalité 
Il clique sur le bouton "Prêter".
Une liste de tous les livre prêter sont afficher.

Règles de gestion:
L'adhérant doit exister dans la base de données.
Verification de l'age (si livre avec restriction d'age)
L'exemplaire du livre doit être disponible (non emprunté ou réservé).
Le quota d'emprunts de l'adhérant (défini par le bibliothécaire pour le type : étudiant, professionnel, professeur) ne doit pas être dépassé.
L'adhérant ne doit pas avoir de sanction active (pénalité en cours).
L'abonnement de l'adhérant doit être valide (date actuelle entre date de début et date de fin).
Le livre doit être adapté à l'âge de l'adhérant (ex. : certains livres sont réservés aux adhérants de 18 ans ou plus).
si le type de prêt est "lecture sur place" la date de retour est egal à la date d'emprunt sinon une date est donné pour la date de retour.

Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une page d'erreur avec un message expliquant la raison (ex. : "Adhérant non abonné", "Exemplaire non disponible" ou "Livre non adapté à l'âge").

Résultat:
L'exemplaire devient indisponible.
Le quota d'emprunts de l'adhérant est décrémenté de 1.
Un prêt est enregistré pour l'adhérant avec le type de prêt spécifié.


2. Rendre un livre

Nom: Rendre_livre
Objectifs: Permettre à un adhérant de rendre un exemplaire emprunté.
Acteur: Bibliothécaire
Entrée:
Référence de l'exemplaire
Référence de l'adhérant
Date de retour réelle
Nombre de jours de pénalité (si applicable, défini par le bibliothécaire)

Scénario nominal:
Le bibliothécaire se connecte au système.
Il accède au menu "Gestion des retours des livres".
Il entre la référence de l'adhérant et celle de l'exemplaire.
Si un retard est constaté, il spécifie le nombre de jours de pénalité selon le profil.
Il clique sur le bouton "Rendre".

Règles de gestion:
L'adhérant doit exister dans la base de données.
L'exemplaire doit être actuellement emprunté par cet adhérant.
Si le retour est en retard (date réelle > date prévue), le bibliothécaire définit le nombre de jours de pénalité selon le profil de l'adhérant (étudiant, professionnel, professeur), calculé à partir de la date de retour réelle.
Pas de pénalité si la date de retour réelle tombe un jour férié.
Si une réservation existe pour cet exemplaire, il est marqué comme réservé.

Scénario alternatif:
Si l'exemplaire n'est pas emprunté par l'adhérant, afficher une erreur ("Exemplaire non emprunté par cet adhérant").
Si une pénalité est appliquée, informer l'adhérant de la durée de la sanction.

Résultat:
L'exemplaire redevient disponible (ou réservé si une réservation existe).
Le quota d'emprunts de l'adhérant est incrémenté de 1.
Le prêt est marqué comme terminé.
Une pénalité peut être enregistrée (durée définie par le bibliothécaire).


3. Réserver un livre

Nom: Réserver_livre
Objectifs: Permettre à un adhérant de réserver un exemplaire non disponible.
Acteur: Bibliothécaire ou Adhérant (via login)
Entrée:
Référence de l'exemplaire
Référence de l'adhérant
Date de réservation


Scénario nominal:
L'utilisateur (bibliothécaire ou adhérant connecté) accède au menu "Réserver un livre".
Il entre la référence de l'adhérant et celle de l'exemplaire.
Il verifie la disponibilité de l'exemplaire
Il clique sur le bouton "Réserver".


Règles de gestion:
L'adhérant doit exister dans la base de données.
L'exemplaire doit être indisponible (emprunté ou déjà réservé).
Le quota de réservations de l'adhérant (défini par le bibliothécaire pour le type : étudiant, professionnel, professeur) ne doit pas être dépassé.
L'adhérant ne doit pas avoir de sanction active.
L'abonnement de l'adhérant doit être valide (date actuelle entre date de début et date de fin).
Le livre doit être adapté à l'âge de l'adhérant (ex. : certains livres réservés aux 18 ans et plus).


Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Adhérant sanctionné", "Exemplaire déjà réservé" ou "Livre non adapté à l'âge").


Résultat:
Une réservation est enregistrée pour l'exemplaire.
L'exemplaire reste indisponible jusqu'à ce que la réservation soit honorée ou annulée.



4. Prolonger un prêt

Nom: Prolonger_prêt
Objectifs: Permettre à un adhérant de prolonger la durée d'un prêt.
Acteur: Bibliothécaire ou Adhérant (via login)
Entrée:
Référence de l'exemplaire
Référence de l'adhérant
Nouvelle date de retour souhaitée

Scénario nominal:
L'utilisateur (bibliothécaire ou adhérant connecté) accède au menu "Prolonger un prêt".
Il entre la référence de l'adhérant et celle de l'exemplaire.
Il sélectionne une nouvelle date de retour.
Il clique sur le bouton "Prolonger".

Règles de gestion:
L'adhérant doit exister dans la base de données.
L'exemplaire doit être actuellement emprunté par cet adhérant.
Le nombre de prolongements autorisés (défini par le bibliothécaire pour le type : étudiant, professionnel, professeur) n'est pas dépassé.
Aucune réservation ne doit exister pour cet exemplaire (priorité à la réservation).
L'adhérant ne doit pas avoir de sanction active.
L'abonnement de l'adhérant doit être valide.

Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Prolongement non autorisé, exemplaire réservé").

Résultat:
La date de retour du prêt est mise à jour.
Le compteur de prolongements est incrémenté.



5. Ajouter un adhérant(CHECK)

Nom: Ajouter_adhérant
Objectifs: Inscrire un nouvel adhérant dans le système avec un abonnement et des quotas personnalisés.
Acteur: Bibliothécaire
Entrée:
Nom, prénom, type d'adhérant (étudiant, professionnel, professeur)
Âge de l'adhérant(date de naissance)
Coordonnées (email)
Date de début et date de fin de l'abonnement
Identifiants de connexion (email, mot de passe)
Quota d'emprunts (défini par le bibliothécaire)
Quota de réservations (défini par le bibliothécaire)
Nombre de prolongements autorisés (défini par le bibliothécaire)


Scénario nominal:
Le bibliothécaire se connecte au système.
Il accède au menu "Ajouter un adhérant".
Il remplit les informations de l'adhérant (nom, prénom, type, âge, coordonnées, login, mot de passe).
les quotas d'emprunts, de réservations et de prolongements sont définies automatiquement lorsqu'on selecte un type d'adhérant. (les quotas ne s'affiche pas dans le formulaire mais dans la liste)
Il enregistre les dates de début de l'abonnement.
Il clique sur le bouton "Ajouter".
Une liste des adhérants s'affiche avec nom, prenom, type, les quotas, et la date de fin
on peut supprimer, modifier 


Règles de gestion:
Les informations obligatoires (nom, prénom, type, âge, login, mot de passe) doivent être fournies.
L'email doit être uniques (pas de doublons).
Les dates de début et de fin de l'abonnement doivent être valides (date de fin > date de début).
Les quotas d'emprunts, de réservations et de prolongements doivent être des valeurs positives.
Le type d'adhérant doit être valide (étudiant, professionnel, professeur).


Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Login déjà utilisé" ou "Quotas invalides").


Résultat:
Un nouvel adhérant est ajouté à la base de données.
Un abonnement est enregistré avec les dates spécifiées.
Les quotas d'emprunts, de réservations et de prolongements sont initialisés.
Les identifiants de connexion sont activés.



6. Renouveler un abonnement(CHECK)

Nom: Renouveler_abonnement
Objectifs: Permettre à un adhérant de prolonger la durée de son abonnement.
Acteur: Adhérant (via login) ou Bibliothécaire
Entrée:
Référence de l'adhérant
Nouvelle date de fin de l'abonnement


Scénario nominal:
L'utilisateur (adhérant connecté ou bibliothécaire) accède au menu "Renouveler un abonnement".
Il entre la référence de l'adhérant.
Il verifie l'éligibilité (pénalités réglés).
Il spécifie la nouvelle date de fin de l'abonnement.
Il clique sur le bouton "Renouveler".


Règles de gestion:
L'adhérant doit exister dans la base de données.
La nouvelle date de fin doit être postérieure à la date de fin actuelle de l'abonnement.
L'adhérant ne doit pas avoir de sanction active (pour un renouvellement par l'adhérant lui-même).


Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Adhérant non trouvé" ou "Nouvelle date de fin invalide").


Résultat:
La date de fin de l'abonnement est mise à jour dans la base de données.
L'adhérant reste actif pour les emprunts et réservations.



7. Gérer les pénalités

Nom: Gérer_pénalités
Objectifs: Enregistrer ou supprimer une pénalité pour un adhérant en cas de retard ou autre infraction.
Acteur: Bibliothécaire
Entrée:
Référence de l'adhérant
Type de pénalité (retard)
Date de retour prévue
Date de retour réelle (pour les pénalités de retard)
Nombre de jours de pénalité (défini par le bibliothécaire selon le profil)


Scénario nominal:
Le bibliothécaire se connecte au système.
Il accède au menu "Gérer les pénalités".
Il entre la référence de l'adhérant et les détails de la pénalité.
Pour un retard, il spécifie le nombre de jours de pénalité selon le profil.(calcul des pénalités >date de retour reel + nbr de jours de pénalité selon le bibliothécaire)
Il clique sur le bouton "Appliquer" ou "Supprimer".


Règles de gestion:
L'adhérant doit exister dans la base de données.
Pour une pénalité de retard, le bibliothécaire définit le nombre de jours de sanction à partir de la date de retour réelle, selon le profil (étudiant, professionnel, professeur).
Pas de pénalité si la date de retour réelle tombe un jour férié.
Une pénalité active empêche l'adhérant d'emprunter ou de réserver.


Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Adhérant non trouvé" ou "Nombre de jours de pénalité invalide").


Résultat:
Une pénalité est ajoutée ou supprimée pour l'adhérant.
L'adhérant est bloqué pour les emprunts et réservations si la pénalité est active.



8. Gérer les jours fériés (CHECK)

Nom: Gérer_jours_fériés
Objectifs: Enregistrer les jours fériés pour éviter les pénalités de retard.
Acteur: Bibliothécaire
Entrée:
Date du jour férié
Description

Scénario nominal:
Le bibliothécaire se connecte au système.
Il accède au menu "Gérer des jours fériés".
Il entre la date du jour férié et une description .
Il clique sur le bouton "Enregistrer".

Règles de gestion:
La date doit être valide et unique (pas de doublons).
La date ne doit pas être antérieure à la date actuelle.

Scénario alternatif:
Si la date est invalide ou déjà enregistrée, afficher une erreur.

Résultat:
Le jour férié est ajouté à la base de données.
Les pénalités de retard sont désactivées pour cette date.(SAUF CECI)



9. Connexion adhérant

Nom: Connexion_adhérant
Objectifs: Permettre à un adhérant de se connecter au système pour accéder à ses fonctionnalités (réservation, prolongement, renouvellement d'abonnement).
Acteur: Adhérant
Entrée:
Login
Mot de passe


Scénario nominal:
L'adhérant accède à l'interface de connexion.
Il entre son login et son mot de passe.
Il clique sur le bouton "Se connecter".


Règles de gestion:
Le login et le mot de passe doivent correspondre à un adhérant existant.
L'abonnement de l'adhérant doit être valide (date actuelle entre date de début et date de fin).
L'adhérant ne doit pas avoir de sanction active.


Scénario alternatif:
Si une règle de gestion n'est pas respectée, afficher une erreur (ex. : "Identifiants incorrects" ou "Compte sanctionné").


Résultat:
L'adhérant est connecté et peut accéder aux fonctionnalités autorisées (réservation, prolongement, renouvellement d'abonnement).


le prolongement ou le reservation qui arrive en premier est en priorite