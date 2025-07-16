<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Réservations - Bibliothèque</title>
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
            margin-bottom: 20px;
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
        
        .form-group input {
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
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
        
        .btn-danger {
            background-color: #dc3545;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-success {
            background-color: #28a745;
        }
        
        .btn-success:hover {
            background-color: #218838;
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
        
        .exemplaire-info {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
        }
        
        .exemplaire-info h4 {
            margin: 0 0 10px 0;
            color: #333;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .status-disponible {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-emprunte {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status-reserve {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-en-attente {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .status-acceptee {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-refusee {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status-annulee {
            background-color: #e2e3e5;
            color: #6c757d;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .table th, .table td {
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
            background-color: #f8f9fa;
        }
        
        .no-data {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>Réservations</h1>
            <a href="/adherant/dashboard" class="back-btn">Retour au tableau de bord</a>
        </div>
    </div>
    
    <div class="main-content">
        <!-- Messages d'erreur ou de succès -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>
        
        <!-- Formulaire de recherche d'exemplaire -->
        <div class="card">
            <h2>Rechercher un exemplaire</h2>
            <form action="/adherant/reservations/rechercher" method="post">
                <div class="form-group">
                    <label for="referenceExemplaire">Référence de l'exemplaire :</label>
                    <input type="text" id="referenceExemplaire" name="referenceExemplaire" 
                           placeholder="Entrez la référence de l'exemplaire" required>
                </div>
                <button type="submit" class="btn">Rechercher</button>
            </form>
        </div>
        
        <!-- Informations sur l'exemplaire trouvé -->
        <c:if test="${not empty exemplaire}">
            <div class="card">
                <h2>Exemplaire trouvé</h2>
                <div class="exemplaire-info">
                    <h4>Livre : ${exemplaire.livre.titre}</h4>
                    <p><strong>Auteur :</strong> ${exemplaire.livre.auteur}</p>
                    <p><strong>ISBN :</strong> ${exemplaire.livre.isbn}</p>
                    <p><strong>Âge minimum :</strong> ${exemplaire.livre.ageMinimum} ans</p>
                    <p><strong>Référence exemplaire :</strong> ${exemplaire.id}</p>
                    <p><strong>Statut :</strong> 
                        <span class="status-badge 
                            <c:choose>
                                <c:when test="${exemplaire.statut == 'DISPONIBLE'}">status-disponible</c:when>
                                <c:when test="${exemplaire.statut == 'EMPRUNTE'}">status-emprunte</c:when>
                                <c:when test="${exemplaire.statut == 'RESERVE'}">status-reserve</c:when>
                            </c:choose>
                        ">${exemplaire.statut}</span>
                    </p>
                </div>
                
                <c:choose>
                    <c:when test="${exemplaireDisponible}">
                        <div class="alert alert-success">
                            Cet exemplaire est disponible ! Vous pouvez l'emprunter directement.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form action="/adherant/reservations/reserver" method="post">
                            <input type="hidden" name="exemplaireId" value="${exemplaire.id}">
                            <button type="submit" class="btn btn-success">Faire une demande de réservation</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- Liste des demandes de réservation -->
        <div class="card">
            <h2>Mes demandes de réservation</h2>
            <c:choose>
                <c:when test="${empty demandesReservation}">
                    <div class="no-data">
                        Vous n'avez aucune demande de réservation.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Livre</th>
                                <th>Auteur</th>
                                <th>Référence</th>
                                <th>Date demande</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="demande" items="${demandesReservation}">
                                <tr>
                                    <td>${demande.exemplaire.livre.titre}</td>
                                    <td>${demande.exemplaire.livre.auteur}</td>
                                    <td>${demande.exemplaire.id}</td>
                                    <td>${demande.dateDemande}</td>
                                    <td>
                                        <span class="status-badge 
                                            <c:choose>
                                                <c:when test="${demande.statut == 'EN_ATTENTE'}">status-en-attente</c:when>
                                                <c:when test="${demande.statut == 'ACCEPTEE'}">status-acceptee</c:when>
                                                <c:when test="${demande.statut == 'REFUSEE'}">status-refusee</c:when>
                                                <c:when test="${demande.statut == 'ANNULEE'}">status-annulee</c:when>
                                            </c:choose>
                                        ">${demande.statut}</span>
                                    </td>
                                    <td>
                                        <c:if test="${demande.statut == 'EN_ATTENTE'}">
                                            <form action="/adherant/reservations/annuler/${demande.id}" method="post" style="display: inline;">
                                                <button type="submit" class="btn btn-danger" 
                                                        onclick="return confirm('Êtes-vous sûr de vouloir annuler cette demande ?')">
                                                    Annuler
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${demande.statut == 'REFUSEE' && not empty demande.motifRefus}">
                                            <small style="color: #dc3545;">Motif: ${demande.motifRefus}</small>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Informations sur les quotas -->
        <div class="card">
            <h2>Vos quotas</h2>
            <p><strong>Réservations restantes :</strong> ${adherant.quotaRestantResa}</p>
            <p><strong>Type d'adhérant :</strong> ${adherant.typeAdherant.nomType}</p>
        </div>
    </div>
</body>
</html>