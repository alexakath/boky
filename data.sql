-- Insertion des types d'adhérents (DOIT être fait en premier)
INSERT INTO Typeadherant (nom_type, quota_emprunts, quota_reservations, quota_prolongements, jours_penalite,jours_pret)
VALUES
('Étudiant', 2, 1, 3, 10, 7),
('Enseignant', 3, 2, 5, 9, 9),
('Professionnel', 4, 3, 7, 8, 12);

-- Insertion des adhérents (maintenant les id_type_adherant existent)
INSERT INTO Adherant (num_adherant, nom, prenom, date_naissance, email, mot_de_passe, id_type_adherant, quota_restant_emprunt, quota_restant_resa, quota_restant_prolog)
VALUES
('ETU001','Amine', 'Bensaïd', '2000-05-12', 'amine@gmail.com', 'password123', 1, 2, 1, 3 ),
('ETU002','Sarah', 'El Khattabi', '2000-05-12', 'Sarah@gmail.com', 'password456', 1, 2, 1, 3),
('ETU003','Youssef', 'Moujahid', '2000-05-12', 'Youssef@gmail.com', 'password789', 1, 2, 1, 3),
('ENS001','Nadia', 'Benali', '2000-05-12', 'Nadia@gmail.com', 'password987', 2, 3, 2, 5),
('ENS002','Karim', 'Haddadi', '2000-05-12', 'Karim@gmail.com', 'password654', 2, 3, 2, 5),
('ENS003','Salima', 'Touhami', '2000-05-12', 'Salima@gmail.com', 'password3212', 2, 3, 2, 5),
('PROF001','Rachid', 'El Mansouri', '2000-05-12', 'Rachid@gmail.com', 'password000', 3, 4, 3, 7),
('PROF002','Amina', 'Zerouali', '2000-05-12', 'Amina@gmail.com', 'password111', 3, 4, 3, 7);


INSERT INTO Livre (titre, auteur,categorie, langue, age_minimum, isbn)
VALUES 
    ('Les Misérables', 'Victor Hugo','Littérature classique','Français', 18, '9782070409189'),
    ('L\'Étranger', 'Albert Camus','Philosophie', 'Français',  18, '9782070360022'),
    ('Harry Potter à l\'école des sorciers', 'J.K. Rowling','Jeunesse / Fantastique', 'Français', 18, '9782070643026');

-- Données pour Exemplaire
INSERT INTO Exemplaire (id_livre, statut)
VALUES 
    (1, 'DISPONIBLE'), -- Exemplaire 1 : Le Petit Prince
    (1, 'DISPONIBLE'), -- Exemplaire 2 : Le Petit Prince
    (1, 'DISPONIBLE'), -- Exemplaire 2 : Le Petit Prince
    (2, 'DISPONIBLE'), -- Exemplaire 2 : Le Petit Prince
    (2, 'DISPONIBLE'), -- Exemplaire 2 : Le Petit Prince  -- Exemplaire 4 : 1984
    (3, 'DISPONIBLE'); -- Exemplaire 5 : Harry Potter

-- Données pour Abonnement
-- Abonnement (dates corrigées)
INSERT INTO Abonnement (id_adherant, date_debut, date_fin)
VALUES 
    (1, '2025-02-01', '2025-07-24'),
    (2, '2025-02-01', '2025-07-01'),
    (3, '2025-02-02', '2025-12-01'),
    (4, '2025-02-02', '2026-07-01'),
    (5, '2025-02-04', '2026-05-01'),
    (6, '2025-02-05', '2026-06-01'),
    (7, '2025-02-06', '2025-12-01'),
    (8, '2025-02-07', '2025-06-01');

-- JourFerier (dates corrigées)
INSERT INTO jourferier (date_ferier, description)
VALUES 
    ('2025-07-13','Dimanche'),
    ('2025-07-20','Dimanche'),
    ('2025-07-27','Dimanche'),
    ('2025-08-03','Dimanche'),
    ('2025-08-10','Dimanche'),
    ('2025-08-17','Dimanche'),
    ('2025-07-26','Jour férié'),
    ('2025-07-19','Jour férié');
