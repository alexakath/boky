<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prolonger un prêt - Bibliothèque</title>
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
        
        .back-btn {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .back-btn:hover {
            background-color: #5a6268;
        }
        
        .main-content {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .card h2 {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group select,
        .form-group input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
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
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .table tr:hover {
            background-color: #f5f5f5;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-en-attente {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-acceptee {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-refusee {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .info-text {
            color: #666;
            font-style: italic;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>Prolonger un prêt</h1>
            <a href="/adherant/dashboard" class="back-btn">Retour au tableau de bord</a>
        </div>
    </div>
    
    <div class="main-content">
        <!-- Messages d'erreur ou de succès -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>
        
        <!-- Formulaire de demande de prolongement -->
        <div class="card">
            <h2>Faire une demande de prolongement</h2>
            
            <c:choose>
                <c:when test="${empty pretsActifs}">
                    <p class="info-text">Vous n'avez actuellement aucun prêt en cours.</p>
                </c:when>
                <c:otherwise>
                    <form method="post" action="/adherant/prolongements">
                        <div class="form-group">
                            <label for="exemplaireId">Sélectionnez l'exemplaire à prolonger :</label>
                            <select name="exemplaireId" id="exemplaireId" required>
                                <option value="">-- Choisir un exemplaire --</option>
                                <c:forEach var="pret" items="${pretsActifs}">
                                    <option value="${pret.exemplaire.id}">
                                        ${pret.exemplaire.livre.titre} - ${pret.exemplaire.livre.auteur} 
                                        (Retour prévu: ${pret.dateRetourPrevue})
                                        [${pret.nombreProlongements} prolongement(s) effectué(s)]
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="nouvelleDateRetour">Nouvelle date de retour souhaitée :</label>
                            <input type="date" name="nouvelleDateRetour" id="nouvelleDateRetour" required>
                        </div>
                        
                        <button type="submit" class="btn">Prolonger</button>
                    </form>
                    
                    <p class="info-text">
                        Une demande de prolongement sera envoyée au bibliothécaire pour validation.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Tableau des prêts en cours -->
        <div class="card">
            <h2>Mes prêts en cours</h2>
            
            <c:choose>
                <c:when test="${empty pretsActifs}">
                    <p class="info-text">Aucun prêt en cours.</p>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Titre</th>
                                <th>Auteur</th>
                                <th>Date d'emprunt</th>
                                <th>Date de retour prévue</th>
                                <th>Prolongements</th>
                                <th>Type</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pret" items="${pretsActifs}">
                                <tr>
                                    <td>${pret.exemplaire.livre.titre}</td>
                                    <td>${pret.exemplaire.livre.auteur}</td>
                                    <td>${pret.datePret}</td>
                                    <td>${pret.dateRetourPrevue}</td>
                                    <td>${pret.nombreProlongements}</td>
                                    <td>${pret.typePret}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Tableau des demandes de prolongement -->
        <div class="card">
            <h2>Mes demandes de prolongement</h2>
            
            <c:choose>
                <c:when test="${empty demandes}">
                    <p class="info-text">Aucune demande de prolongement.</p>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Livre</th>
                                <th>Date de demande</th>
                                <th>Nouvelle date souhaitée</th>
                                <th>Statut</th>
                                <th>Motif (si refusé)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="demande" items="${demandes}">
                                <tr>
                                    <td>${demande.pret.exemplaire.livre.titre}</td>
                                    <td>${demande.dateDemande}</td>
                                    <td>${demande.nouvelleDateRetour}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${demande.statut == 'EN_ATTENTE'}">
                                                <span class="status-badge status-en-attente">En attente</span>
                                            </c:when>
                                            <c:when test="${demande.statut == 'ACCEPTEE'}">
                                                <span class="status-badge status-acceptee">Acceptée</span>
                                            </c:when>
                                            <c:when test="${demande.statut == 'REFUSEE'}">
                                                <span class="status-badge status-refusee">Refusée</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${demande.statut == 'REFUSEE' && not empty demande.motifRefus}">
                                            ${demande.motifRefus}
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>