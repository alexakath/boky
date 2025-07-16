-- Création de la base de données
CREATE DATABASE bibliotheque;
USE bibliotheque;

-- Table des livres
CREATE TABLE Livre (
    id_livre INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(100),
    age_minimum INT NOT NULL DEFAULT 0, -- Âge minimum requis pour emprunter (ex. 18 pour certains livres)
    isbn VARCHAR(13) UNIQUE
);

-- Table des exemplaires
CREATE TABLE Exemplaire (
    id_exemplaire INT AUTO_INCREMENT PRIMARY KEY,
    id_livre INT NOT NULL,
    statut ENUM('DISPONIBLE', 'EMPRUNTE', 'RESERVE') NOT NULL DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre) ON DELETE CASCADE
);

-- Table des types d'adhérants
CREATE TABLE TypeAdherant (
    id_type_adherant INT AUTO_INCREMENT PRIMARY KEY,
    nom_type VARCHAR(100) NOT NULL,
    quota_emprunts INT NOT NULL,
    quota_reservations INT NOT NULL,
    quota_prolongements INT NOT NULL,
    jours_penalite INT NOT NULL
);

-- Table des adhérants
CREATE TABLE Adherant (
    id_adherant INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    id_type_adherant INT NOT NULL,
    quota_restant_emprunt INT NOT NULL DEFAULT 0, -- Nombre d'emprunts restants (initialisé via AdherantService)
    quota_restant_resa INT NOT NULL DEFAULT 0, -- Nombre de reservation restants (initialisé via AdherantService)
    quota_restant_prolog INT NOT NULL DEFAULT 0, -- Nombre de prolongement restants (initialisé via AdherantService)
    FOREIGN KEY (id_type_adherant) REFERENCES TypeAdherant(id_type_adherant) ON DELETE RESTRICT
);

-- Table des abonnements
CREATE TABLE Abonnement (
    id_abonnement INT AUTO_INCREMENT PRIMARY KEY,
    id_adherant INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    CHECK (date_fin > date_debut),
    FOREIGN KEY (id_adherant) REFERENCES Adherant(id_adherant) ON DELETE CASCADE
);

-- Table des prêts
CREATE TABLE Pret (
    id_pret INT AUTO_INCREMENT PRIMARY KEY,
    id_exemplaire INT NOT NULL,
    id_adherant INT NOT NULL,
    date_pret DATE NOT NULL,
    date_retour_prevue DATE NOT NULL,
    date_retour_reelle DATE,
    type_pret ENUM('LECTURE_SUR_PLACE', 'A_EMPORTER') NOT NULL,
    nombre_prolongements INT DEFAULT 0,
    CHECK (date_retour_prevue >= date_pret),
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherant) REFERENCES Adherant(id_adherant) ON DELETE CASCADE
);

-- Table des réservations
CREATE TABLE Reservation (
    id_reservation INT AUTO_INCREMENT PRIMARY KEY,
    id_exemplaire INT NOT NULL,
    id_adherant INT NOT NULL,
    date_reservation DATE NOT NULL,
    statut ENUM('en_attente', 'honoree', 'annulee') NOT NULL DEFAULT 'en_attente',
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherant) REFERENCES Adherant(id_adherant) ON DELETE CASCADE
);

-- Table pour les demandes de réservation
CREATE TABLE DemandeReservation (
    id_demande_reservation INT AUTO_INCREMENT PRIMARY KEY,
    id_exemplaire INT NOT NULL,
    id_adherant INT NOT NULL,
    date_demande DATE NOT NULL,
    statut ENUM('EN_ATTENTE', 'ACCEPTEE', 'REFUSEE', 'ANNULEE') NOT NULL DEFAULT 'EN_ATTENTE',
    motif_refus TEXT,
    date_validation DATE,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire) ON DELETE CASCADE,
    FOREIGN KEY (id_adherant) REFERENCES Adherant(id_adherant) ON DELETE CASCADE
);

-- Table des pénalités
CREATE TABLE Penalite (
    id_penalite INT AUTO_INCREMENT PRIMARY KEY,
    id_adherant INT NOT NULL,
    id_pret INT, -- Lien vers le prêt spécifique (facultatif)
    type_penalite ENUM('RETARD') NOT NULL,
    date_debut_penalite DATE NOT NULL,
    nombre_jours INT NOT NULL,
    date_fin_penalite DATE NOT NULL,
    CHECK (date_fin_penalite >= date_debut_penalite),
    FOREIGN KEY (id_adherant) REFERENCES Adherant(id_adherant) ON DELETE CASCADE,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret) ON DELETE SET NULL
);

-- Table des jours fériés
CREATE TABLE JourFerier (
    id_jour_ferier INT AUTO_INCREMENT PRIMARY KEY,
    date_ferier DATE NOT NULL UNIQUE,
    date_fin_penalite DATE,
    description VARCHAR(255),
    CHECK (date_ferier >= CURDATE())
);

-- Table pour les demandes de prolongement
CREATE TABLE DemandeProlongement (
    id_demande INT AUTO_INCREMENT PRIMARY KEY,
    id_pret INT NOT NULL,
    nouvelle_date_retour DATE NOT NULL,
    date_demande DATE NOT NULL,
    statut ENUM('EN_ATTENTE', 'ACCEPTEE', 'REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
    motif_refus TEXT,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret) ON DELETE CASCADE
);
-- Données pour TypeAdherant
INSERT INTO TypeAdherant (nom_type, quota_emprunts, quota_reservations, quota_prolongements)
VALUES ('étudiant', 3, 2, 2),
       ('professionnel', 5, 3, 2),
       ('professeur', 5, 5, 3);