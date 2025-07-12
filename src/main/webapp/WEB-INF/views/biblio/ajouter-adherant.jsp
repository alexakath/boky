<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un Adhérant - Bibliothèque</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1, h2 {
            color: #333;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"], input[type="email"], input[type="password"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .error {
            color: red;
            margin-bottom: 20px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f0f0f0;
            color: #333;
        }
        .action-btn {
            background-color: #FF9800;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 5px;
        }
        .action-btn.delete {
            background-color: #f44336;
        }
        .action-btn:hover {
            opacity: 0.8;
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
    <div class="container">
        <h1>Gestion des Adhérants</h1>
        
        <!-- Formulaire d'ajout -->
        <h2>Ajouter un nouvel adhérant</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="/adherants/ajouter" method="post">
            <div class="form-group">
                <label for="nom">Nom :</label>
                <input type="text" id="nom" name="nom" required>
            </div>
            <div class="form-group">
                <label for="prenom">Prénom :</label>
                <input type="text" id="prenom" name="prenom" required>
            </div>
            <div class="form-group">
                <label for="dateNaissance">Date de naissance :</label>
                <input type="date" id="dateNaissance" name="dateNaissance" required>
            </div>
            <div class="form-group">
                <label for="email">Email :</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="motDePasse">Mot de passe :</label>
                <input type="password" id="motDePasse" name="motDePasse" required>
            </div>
            <div class="form-group">
                <label for="typeAdherant">Type d'adhérant :</label>
                <select id="typeAdherant" name="typeAdherantId" required>
                    <option value="">Sélectionner un type</option>
                    <c:forEach var="type" items="${typesAdherant}">
                        <option value="${type.id}">${type.nomType}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="dateDebut">Date de début d'abonnement :</label>
                <input type="date" id="dateDebut" name="dateDebut" required>
            </div>
            <button type="submit" class="btn">Ajouter</button>
        </form>
        
        <!-- Liste des adhérants -->
        <h2>Liste des adhérants</h2>
        <table>
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Type</th>
                    <th>Quota Emprunts</th>
                    <th>Quota Réservations</th>
                    <th>Quota Prolongements</th>
                    <th>Date Début</th>
                    <th>Date Fin</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="adherant" items="${adherants}">
                    <tr>
                        <td>${adherant.nom}</td>
                        <td>${adherant.prenom}</td>
                        <td>${adherant.typeAdherant.nomType}</td>
                        <td>${adherant.quotaRestantEmprunt}</td>
                        <td>${adherant.quotaRestantResa}</td>
                        <td>${adherant.quotaRestantProlog}</td>
                        <td>
                            <c:forEach var="abonnement" items="${adherant.abonnements}">
                                ${abonnement.dateDebut}
                            </c:forEach>
                        </td>
                        <td>
                            <c:forEach var="abonnement" items="${adherant.abonnements}">
                                ${abonnement.dateFin}
                            </c:forEach>
                        </td>
                        <td>
                            <form action="/adherants/modifier/${adherant.id}" method="get" style="display:inline;">
                                <button type="submit" class="action-btn">Modifier</button>
                            </form>
                            <form action="/adherants/supprimer/${adherant.id}" method="post" style="display:inline;">
                                <button type="submit" class="action-btn delete">Supprimer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>