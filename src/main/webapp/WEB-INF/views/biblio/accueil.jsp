<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accueil Bibliothécaire - Bibliothèque</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .header {
            background-color: #FF9800;
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            margin: 0;
            font-size: 28px;
        }
        
        .welcome-message {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin-bottom: 30px;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .menu-item {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .menu-item:hover {
            transform: translateY(-5px);
        }
        
        .menu-item h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .menu-item p {
            color: #666;
            font-size: 14px;
        }
        
        .menu-item a {
            color: #2196F3;
            text-decoration: none;
            font-weight: bold;
        }
        
        .menu-item a:hover {
            color: #1976D2;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #666;
            text-decoration: none;
        }
        
        .back-link a:hover {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Espace Bibliothécaire</h1>
    </div>
    
    <div class="container">
        <div class="welcome-message">
            <h2>Bienvenue dans l'espace bibliothécaire</h2>
            <p>Vous pouvez gérer la bibliothèque depuis cet espace.</p>
        </div>
        
        <div class="menu-grid">
            <div class="menu-item">
                <h3>Gestion des Livres</h3>
                <p>Ajouter, modifier et supprimer des livres</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Adhérents</h3>
                <p><a href="/adherants/ajouter">Gérer les adhérents et leurs abonnements</a></p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Abonnements</h3>
                <p><a href="/abonnements/renouveler" class="btn btn-info">Renouveler un Abonnement</a></p>
            </div>

            <div class="menu-item">
                <h3>Gestion des Prêts</h3>
                <p>Enregistrer et suivre les prêts</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Prolongements</h3>
                <p>Suivre les demandes de prolongement des livres</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Retours des livres</h3>
                <p>Enregistrer et suivre les livres rendus</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Réservations</h3>
                <p>Traiter les réservations</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des Pénalités</h3>
                <p>Suivre et gérer les pénalités</p>
            </div>
            
            <div class="menu-item">
                <h3>Gestion des jours fériés</h3>
                <p>Suivre et gérer les jours fériés</p>
            </div>
        </div>
        
        <div class="back-link">
            <a href="/">← Retour au choix de connexion</a>
        </div>
    </div>
</body>
</html>