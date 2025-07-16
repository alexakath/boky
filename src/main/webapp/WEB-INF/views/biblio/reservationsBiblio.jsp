<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Réservations - Bibliothèque</title>
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
        
        .alert {
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .demandes-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .demande-item {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #f9f9f9;
        }
        
        .demande-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .demande-title {
            font-weight: bold;
            color: #333;
            font-size: 16px;
        }
        
        .demande-date {
            color: #666;
            font-size: 14px;
        }
        
        .demande-details {
            margin-bottom: 15px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .detail-label {
            font-weight: bold;
            width: 150px;
            color: #555;
        }
        
        .detail-value {
            color: #333;
        }
        
        .actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #218838;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .motif-refus {
            margin-left: 10px;
        }
        
        .motif-refus input {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 3px;
            width: 200px;
        }
        
        .no-demandes {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 40px;
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
        
        .statut-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .statut-en-attente {
            background-color: #fff3cd;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Gestion des Réservations</h1>
    </div>
    
    <div class="container">
        <!-- Messages de succès/erreur -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
        </c:if>
        
        <div class="demandes-container">
            <h2>Demandes de Réservation en Attente</h2>
            
            <c:choose>
                <c:when test="${empty demandesReservation}">
                    <div class="no-demandes">
                        <p>Aucune demande de réservation en attente.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="demande" items="${demandesReservation}">
                        <div class="demande-item">
                            <div class="demande-header">
                                <div class="demande-title">
                                    Demande #${demande.id}
                                    <span class="statut-badge statut-en-attente">${demande.statut}</span>
                                </div>
                                <div class="demande-date">
                                    ${demande.dateDemande}
                                </div>
                            </div>
                            
                            <div class="demande-details">
                                <div class="detail-row">
                                    <div class="detail-label">Adhérent :</div>
                                    <div class="detail-value">${demande.adherant.nom} ${demande.adherant.prenom}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Email :</div>
                                    <div class="detail-value">${demande.adherant.email}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Type d'adhérent :</div>
                                    <div class="detail-value">${demande.adherant.typeAdherant.nomType}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Livre :</div>
                                    <div class="detail-value">${demande.exemplaire.livre.titre}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Auteur :</div>
                                    <div class="detail-value">${demande.exemplaire.livre.auteur}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Exemplaire ID :</div>
                                    <div class="detail-value">#${demande.exemplaire.id}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Statut exemplaire :</div>
                                    <div class="detail-value">${demande.exemplaire.statut}</div>
                                </div>
                                
                                <div class="detail-row">
                                    <div class="detail-label">Quota réservations restant :</div>
                                    <div class="detail-value">${demande.adherant.quotaRestantResa}</div>
                                </div>
                            </div>
                            
                            <div class="actions">
                                <form method="post" action="/reservations/valider/${demande.id}" style="display: inline;">
                                    <button type="submit" class="btn btn-success">Valider</button>
                                </form>
                                
                                <form method="post" action="/reservations/rejeter/${demande.id}" style="display: inline;">
                                    <button type="submit" class="btn btn-danger">Rejeter</button>
                                    <div class="motif-refus">
                                        <input type="text" name="motifRefus" placeholder="Motif de refus (optionnel)">
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil bibliothécaire</a>
        </div>
    </div>
</body>
</html>