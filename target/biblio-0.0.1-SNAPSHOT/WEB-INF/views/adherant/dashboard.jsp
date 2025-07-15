<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Espace Adhérant - Bibliothèque</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .header {
            background-color: #007bff;
            color: white;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .welcome-message {
            font-size: 18px;
        }
        
        .logout-btn {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .logout-btn:hover {
            background-color: #c82333;
        }
        
        .main-content {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
            margin-top: 30px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .card h3 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .card p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .card-btn {
            background-color: #6ea6e2;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            transition: background-color 0.3s;
        }
        
        .card-btn:hover {
            background-color: #405c7a;
        }
        
        .card-btn.secondary {
            background-color: #6c757d;
        }
        
        .card-btn.secondary:hover {
            background-color: #5a6268;
        }

        .card-btn.third{
            background-color: #578073;
        }

        .card-btn.third:hover{
            background-color: #567068;
        }
        
        
        .card-btn.success {
            background-color: #28a745;
        }
        
        .card-btn.success:hover {
            background-color: #218838;
        }
        
        .user-info {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .user-info h2 {
            color: #333;
            margin-bottom: 15px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 5px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: bold;
            color: #333;
        }
        
        .info-value {
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="welcome-message">
                Bienvenue, ${adherant.prenom} ${adherant.nom}
            </div>
            <a href="/adherant/logout" class="logout-btn">Se déconnecter</a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="user-info">
            <h2>Informations personnelles</h2>
            <div class="info-row">
                <span class="info-label">Nom :</span>
                <span class="info-value">${adherant.nom}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Prénom :</span>
                <span class="info-value">${adherant.prenom}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Email :</span>
                <span class="info-value">${adherant.email}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Type d'adhérant :</span>
                <span class="info-value">${adherant.typeAdherant.nomType}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Emprunts restants :</span>
                <span class="info-value">${adherant.quotaRestantEmprunt}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Réservations restantes :</span>
                <span class="info-value">${adherant.quotaRestantResa}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Prolongements restants :</span>
                <span class="info-value">${adherant.quotaRestantProlog}</span>
            </div>
        </div>
        <div class="dashboard-grid">
            <div class="card">
                <h3>Réservation</h3>
                <p>Réservez un livre disponible dans notre catalogue</p>
                <a href="/adherant/reservations" class="card-btn">Faire une réservation</a>
            </div>
            
            <div class="card">
                <h3>Prolongement</h3>
                <p>Prolongez vos emprunts en cours</p>
                <a href="/adherant/prolongements" class="card-btn secondary">Prolonger un prêt</a>
            </div>

            <div class="card">
                <h3>Jours Fériés</h3>
                <p>Soyez au courant de nos jours fériés</p>
                <a href="/adherant/jourFerier" class="card-btn third">Aller Voir ></a>
            </div>
            
            <div class="card">
                <h3>Mon abonnement</h3>
                <p>Suivez votre abonnement à la bibliothèque</p>
                <a href="/adherant/abonnement" class="card-btn success">Voir Abonnement</a>
            </div>
            
            <div class="card">
                <h3>Mes pénalités</h3>
                <p>Suivez votre pénalité</p>
                <a href="/adherant/penalite" class="card-btn success">Voir Pénalité</a>
            </div>

            <div class="card">
                <h3>Mon prêts</h3>
                <p>Suivez votre prêt à la bibliothèque</p>
                <a href="/adherant/pret" class="card-btn success">Voir Prêt</a>
            </div>
        </div>
        
        
    </div>
</body>
</html>