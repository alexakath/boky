<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Livres - Bibliothèque</title>
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
        
        .card {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .search-form {
            margin-bottom: 20px;
        }
        
        .search-form input[type="text"] {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 300px;
            margin-right: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        
        .btn-primary {
            background-color: #2196F3;
            color: white;
        }
        
        .btn-success {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-danger {
            background-color: #f44336;
            color: white;
        }
        
        .btn:hover {
            opacity: 0.9;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        
        .table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status {
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-disponible {
            background-color: #4CAF50;
            color: white;
        }
        
        .status-emprunte {
            background-color: #f44336;
            color: white;
        }
        
        .status-reserve {
            background-color: #FF9800;
            color: white;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        .form-inline {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .form-inline input {
            width: auto;
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
        
        .toggle-form {
            margin-bottom: 20px;
        }
        
        .form-container {
            display: none;
            margin-top: 15px;
        }
        
        .form-container.active {
            display: block;
        }
    </style>
    <script>
        function toggleForm(formId) {
            var form = document.getElementById(formId);
            if (form.classList.contains('active')) {
                form.classList.remove('active');
            } else {
                form.classList.add('active');
            }
        }
        
        function confirmDelete(titre) {
            return confirm('Êtes-vous sûr de vouloir supprimer le livre "' + titre + '" ?');
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>Gestion des Livres</h1>
    </div>
    
    <div class="container">
        <!-- Messages d'erreur ou de succès -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>
        
        <div class="card">
            <h2>Rechercher des livres</h2>
            <form method="GET" action="/livres/rechercher" class="search-form">
                <div class="form-inline">
                    <input type="text" name="titre" placeholder="Titre du livre" value="${titreRecherche}">
                    <button type="submit" class="btn btn-primary">Rechercher</button>
                    <a href="/livres/lister" class="btn btn-primary">Afficher tous</a>
                </div>
            </form>
        </div>
        
        <div class="card">
            <div class="toggle-form">
                <button onclick="toggleForm('ajouterForm')" class="btn btn-success">Ajouter un livre</button>
            </div>
            
            <div id="ajouterForm" class="form-container">
                <h3>Ajouter un nouveau livre</h3>
                <form method="POST" action="/livres/ajouter">
                    <div class="form-group">
                        <label for="titre">Titre du livre :</label>
                        <input type="text" id="titre" name="titre" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="auteur">Auteur :</label>
                        <input type="text" id="auteur" name="auteur" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="ageMinimum">Âge minimum :</label>
                        <input type="number" id="ageMinimum" name="ageMinimum" min="0" value="0" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="isbn">ISBN :</label>
                        <input type="text" id="isbn" name="isbn" placeholder="Optionnel">
                    </div>
                    
                    <div class="form-group">
                        <label for="nombreExemplaires">Nombre d'exemplaires :</label>
                        <input type="number" id="nombreExemplaires" name="nombreExemplaires" min="1" value="1" required>
                    </div>
                    
                    <button type="submit" class="btn btn-success">Ajouter le livre</button>
                </form>
            </div>
        </div>
        
        <div class="card">
            <h2>Liste des livres</h2>
            <c:if test="${not empty titreRecherche}">
                <p><strong>Résultats pour la recherche : "${titreRecherche}"</strong></p>
            </c:if>
            
            <c:choose>
                <c:when test="${not empty livres}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Titre</th>
                                <th>Auteur</th>
                                <th>Âge minimum</th>
                                <th>ISBN</th>
                                <th>Nombre d'exemplaires</th>
                                <th>Exemplaires disponibles</th>
                                <th>Exemplaires empruntés</th>
                                <th>Exemplaires réservés</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="livre" items="${livres}">
                                <tr>
                                    <td>${livre.id}</td>
                                    <td><strong>${livre.titre}</strong></td>
                                    <td>${livre.auteur}</td>
                                    <td>${livre.ageMinimum} ans</td>
                                    <td>${livre.isbn}</td>
                                    <td>
                                        <c:set var="totalExemplaires" value="0" />
                                        <c:set var="disponibles" value="0" />
                                        <c:set var="empruntes" value="0" />
                                        <c:set var="reserves" value="0" />
                                        
                                        <c:forEach var="exemplaire" items="${livre.exemplaires}">
                                            <c:set var="totalExemplaires" value="${totalExemplaires + 1}" />
                                            <c:choose>
                                                <c:when test="${exemplaire.statut == 'DISPONIBLE'}">
                                                    <c:set var="disponibles" value="${disponibles + 1}" />
                                                </c:when>
                                                <c:when test="${exemplaire.statut == 'EMPRUNTE'}">
                                                    <c:set var="empruntes" value="${empruntes + 1}" />
                                                </c:when>
                                                <c:when test="${exemplaire.statut == 'RESERVE'}">
                                                    <c:set var="reserves" value="${reserves + 1}" />
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        
                                        ${totalExemplaires}
                                    </td>
                                    <td>
                                        <span class="status status-disponible">${disponibles}</span>
                                    </td>
                                    <td>
                                        <span class="status status-emprunte">${empruntes}</span>
                                    </td>
                                    <td>
                                        <span class="status status-reserve">${reserves}</span>
                                    </td>
                                    <td>
                                        <form method="POST" action="/livres/supprimer/${livre.id}" style="display: inline;">
                                            <button type="submit" class="btn btn-danger" onclick="return confirmDelete('${livre.titre}')">Supprimer</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p>Aucun livre trouvé.</p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil bibliothécaire</a>
        </div>
    </div>
</body>
</html>