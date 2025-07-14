<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rendre un livre - Bibliothèque</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .form-section {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        input[type="text"], input[type="number"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn:hover {
            background-color: #45a049;
        }
        
        .btn-secondary {
            background-color: #666;
        }
        
        .btn-secondary:hover {
            background-color: #555;
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
        
        .prets-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .prets-table th, .prets-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        .prets-table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .prets-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .retard {
            color: #d32f2f;
            font-weight: bold;
        }
        
        .normal {
            color: #388e3c;
        }
        
        .back-link {
            text-align: center;
            margin-top: 30px;
        }
        
        .back-link a {
            color: #666;
            text-decoration: none;
        }
        
        .back-link a:hover {
            color: #333;
        }
        
        .info-box {
            background-color: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .info-box h3 {
            margin-top: 0;
            color: #1976d2;
        }
        
        .info-box p {
            margin: 5px 0;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Rendre un livre</h1>
    </div>
    
    <div class="container">
        <!-- Messages de succès/erreur -->
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
        
        <!-- Informations sur les pénalités -->
        <div class="info-box">
            <h3>Informations importantes</h3>
            <p>• Les pénalités sont calculées automatiquement selon le type d'adhérant</p>
            <p>• Il est interdit de rendre un livre un jour férié</p>
            <p>• Si la date de retour tombe un jour férié, veuillez choisir une date postérieure</p>
        </div>
        
        <!-- Formulaire de retour -->
        <div class="form-section">
            <h2>Enregistrer un retour de livre</h2>
            
            <form action="/retours/rendre" method="post">
                <div class="form-group">
                    <label for="idAdherant">ID Adhérant :</label>
                    <input type="number" id="idAdherant" name="idAdherant" value="${idAdherant}" required>
                </div>
                
                <div class="form-group">
                    <label for="idExemplaire">ID Exemplaire :</label>
                    <input type="number" id="idExemplaire" name="idExemplaire" value="${idExemplaire}" required>
                </div>
                
                <div class="form-group">
                    <label for="dateRetourReelle">Date de retour réelle :</label>
                    <input type="date" id="dateRetourReelle" name="dateRetourReelle" value="${dateRetourReelle}" required>
                    <small style="color: #666; font-size: 14px;">
                        Attention : Il est interdit de rendre un livre un jour férié.
                    </small>
                </div>
                
                <button type="submit" class="btn">Rendre le livre</button>
                <a href="/accueil" class="btn btn-secondary">Annuler</a>
            </form>
        </div>
        
        <!-- Liste des prêts actifs -->
        <div class="form-section">
            <h2>Prêts actifs</h2>
            
            <c:if test="${empty pretsActifs}">
                <p>Aucun prêt actif.</p>
            </c:if>
            
            <c:if test="${not empty pretsActifs}">
                <table class="prets-table">
                    <thead>
                        <tr>
                            <th>ID Prêt</th>
                            <th>Adhérant</th>
                            <th>Type adhérant</th>
                            <th>Livre</th>
                            <th>ID Exemplaire</th>
                            <th>Date d'emprunt</th>
                            <th>Date de retour prévue</th>
                            <th>Type de prêt</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="pret" items="${pretsActifs}">
                            <tr>
                                <td>${pret.id}</td>
                                <td>${pret.adherant.nom} ${pret.adherant.prenom} (ID: ${pret.adherant.id})</td>
                                <td>${pret.adherant.typeAdherant.nomType} (${pret.adherant.typeAdherant.joursPenalite} jours de pénalité)</td>
                                <td>${pret.exemplaire.livre.titre}</td>
                                <td>${pret.exemplaire.id}</td>
                                <td>${pret.datePret}</td>
                                <td>${pret.dateRetourPrevue}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pret.typePret == 'LECTURE_SUR_PLACE'}">Lecture sur place</c:when>
                                        <c:otherwise>À emporter</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <jsp:useBean id="dateObj" class="java.util.Date"/>
                                    <jsp:setProperty name="dateObj" property="time" value="${System.currentTimeMillis()}"/>
                                    <fmt:formatDate value="${dateObj}" pattern="yyyy-MM-dd" var="today"/>
                                    
                                    <c:choose>
                                        <c:when test="${today > pret.dateRetourPrevue}">
                                            <span class="retard">En retard</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="normal">En cours</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil bibliothécaire</a>
        </div>
    </div>
</body>
</html>