<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Pénalités - Bibliothèque</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .header {
            background-color: #FF5722;
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
            font-weight: bold;
        }
        
        .alert-success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }
        
        .alert-error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        
        .actions-section {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-warning {
            background-color: #FF9800;
            color: white;
        }
        
        .btn-danger {
            background-color: #f44336;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.8;
        }
        
        .table-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .table-header {
            background-color: #FF5722;
            color: white;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .status-active {
            color: #f44336;
            font-weight: bold;
        }
        
        .status-expired {
            color: #757575;
            font-style: italic;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
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
        <h1>Gestion des Pénalités</h1>
    </div>
    
    <div class="container">
        <!-- Messages d'alerte -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>
        
        <!-- Section des actions -->
        <div class="actions-section">
            <h3>Actions disponibles</h3>
            <form method="post" action="/penalites/nettoyer-expirees" style="display: inline;">
                <button type="submit" class="btn btn-warning">
                    🧹 Nettoyer les pénalités expirées
                </button>
            </form>
            <p style="margin-top: 10px; color: #666; font-size: 12px;">
                Cette action supprime automatiquement toutes les pénalités dont la date de fin est dépassée.
            </p>
        </div>
        
        <!-- Liste des pénalités -->
        <div class="table-container">
            <div class="table-header">
                📋 Liste des Pénalités Actives
            </div>
            
            <c:choose>
                <c:when test="${not empty penalites}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Référence Adhérant</th>
                                <th>Nom Adhérant</th>
                                <th>Type d'Adhérant</th>
                                <th>Type de Pénalité</th>
                                <th>Nombre de Jours</th>
                                <th>Date de Début</th>
                                <th>Date de Fin</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="penalite" items="${penalites}">
                                <tr>
                                    <td>${penalite.id}</td>
                                    <td>${penalite.adherant.id}</td>
                                    <td>${penalite.adherant.nom} ${penalite.adherant.prenom}</td>
                                    <td>${penalite.adherant.typeAdherant.nomType}</td>
                                    <td>${penalite.typePenalite}</td>
                                    <td>${penalite.nombreJours} jour(s)</td>
                                    <td>
                                        ${penalite.dateDebutPenalite}
                                    </td>
                                    <td>
                                        ${penalite.dateFinPenalite}
                                    </td>
                                    <td>
                                        <jsp:useBean id="dateActuelle" class="java.util.Date" />
                                        <c:choose>
                                            <c:when test="${penalite.active}">
                                                <span class="status-active">🔴 Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-expired">⚪ Expirée</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form method="post" action="/penalites/supprimer/${penalite.id}" style="display: inline;">
                                            <button type="submit" class="btn btn-danger" 
                                                    onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette pénalité ?')">
                                                🗑️ Supprimer
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <p>Aucune pénalité active trouvée.</p>
                        <p>Toutes les pénalités sont soit expirées, soit il n'y en a pas.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Informations sur les règles -->
        <div class="actions-section" style="margin-top: 20px;">
            <h3>📋 Règles de Gestion</h3>
            <ul>
                <li><strong>Pénalités automatiques :</strong> Les pénalités sont automatiquement créées lors du retour en retard d'un livre.</li>
                <li><strong>Durée des pénalités :</strong> La durée dépend du type d'adhérant (étudiant: 3 jours, professionnel: 5 jours, professeur: 7 jours).</li>
                <li><strong>Blocage des emprunts :</strong> Les adhérents avec des pénalités actives ne peuvent pas emprunter de nouveaux livres.</li>
                <li><strong>Suppression automatique :</strong> Les pénalités expirées peuvent être supprimées automatiquement ou manuellement.</li>
            </ul>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil bibliothécaire</a>
        </div>
    </div>
</body>
</html>