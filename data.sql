-- Insertion des types d'adhérents (DOIT être fait en premier)
INSERT INTO Typeadherant (nom_type, quota_emprunts, quota_reservations, quota_prolongements, jours_penalite)
VALUES
('Étudiant', 3, 2, 2, 3),
('Professionnel', 5, 3, 2, 5),
('Professeur', 5, 5, 3, 7);

-- Insertion des adhérents (maintenant les id_type_adherant existent)
INSERT INTO Adherant (nom, prenom, date_naissance, email, mot_de_passe, id_type_adherant, quota_restant_emprunt, quota_restant_resa, quota_restant_prolog)
VALUES
('Rakoto', 'Jean', '2000-05-12', 'jean.rakoto@example.com', 'password123', 1, 3, 2, 2),
('Rabe', 'Marie', '1985-09-25', 'marie.rabe@example.com', 'password456', 2, 5, 3, 2),
('Ando', 'Lova', '2002-11-10', 'lova.ando@example.com', 'password789', 3, 5, 5, 3);

INSERT INTO Livre (titre, auteur, age_minimum, isbn)
VALUES 
    ('Le Petit Prince', 'Antoine de Saint-Exupéry', 0, '9781234567890'),
    ('1984', 'George Orwell', 16, '9780987654321'),
    ('Harry Potter', 'J.K. Rowling', 10, '9781122334455');

-- Données pour Exemplaire
INSERT INTO Exemplaire (id_livre, statut)
VALUES 
    (1, 'DISPONIBLE'), -- Exemplaire 1 : Le Petit Prince
    (1, 'DISPONIBLE'), -- Exemplaire 2 : Le Petit Prince
    (2, 'DISPONIBLE'), -- Exemplaire 3 : 1984
    (2, 'EMPRUNTE'),   -- Exemplaire 4 : 1984
    (3, 'DISPONIBLE'); -- Exemplaire 5 : Harry Potter

-- Données pour Abonnement
INSERT INTO Abonnement (id_adherant, date_debut, date_fin)
VALUES 
    (1, '2025-01-01', '2026-01-01'), -- Jean Rakoto, abonnement actif
    (2, '2025-06-01', '2026-06-01'), -- Marie Rabe, abonnement actif
    (3, '2024-01-01', '2025-01-01'); -- Lova Ando, abonnement expiré

-- Données pour Penalite (exemple avec les bonnes durées)
INSERT INTO Penalite (id_adherant, id_pret, type_penalite, date_debut_penalite, nombre_jours, date_fin_penalite)
VALUES 
    (2, NULL, 'RETARD', '2025-07-01', 5, '2025-07-06'); -- Marie Rabe (Professionnel), 5 jours de pénalité