<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prêter un livre - Bibliothèque</title>
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
        
        .content-wrapper {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-section {
            flex: 1;
            min-width: 500px;
        }
        
        .list-section {
            flex: 1;
            min-width: 500px;
        }
        
        h1 {
            margin: 0;
            font-size: 28px;
        }
        
        h2 {
            margin-top: 0;
            color: #333;
            font-size: 22px;
        }
        
        .form-container, .list-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
        
        input[type="text"], input[type="email"], input[type="password"], input[type="date"], select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        
        .radio-group label {
            display: flex;
            align-items: center;
            font-weight: normal;
            cursor: pointer;
        }
        
        .radio-group input[type="radio"] {
            width: auto;
            margin-right: 8px;
        }
        
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
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
        
        .error {
            color: #d32f2f;
            background-color: #ffebee;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f8bbd9;
        }
        
        .success {
            color: #2e7d32;
            background-color: #e8f5e8;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #a5d6a7;
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
        
        .exemplaire-info {
            background-color: #f0f8ff;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            border: 1px solid #b0d4f1;
        }
        
        .exemplaire-info h4 {
            margin: 0 0 10px 0;
            color: #1976d2;
        }
        
        .exemplaire-info p {
            margin: 5px 0;
            color: #555;
        }
        
        /* Styles pour la table des prêts */
        .prets-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .prets-table th, .prets-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        
        .prets-table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        .prets-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .prets-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .type-pret {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 12px;
            color: white;
            font-weight: bold;
        }
        
        .type-emporter {
            background-color: #2196F3;
        }
        
        .type-sur-place {
            background-color: #4CAF50;
        }
        
        .date-retour {
            font-weight: bold;
        }
        
        .retard {
            color: #d32f2f;
        }
        
        .normal {
            color: #333;
        }
        
        .no-prets {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 20px;
        }
        
        .prets-count {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        @media (max-width: 1024px) {
            .content-wrapper {
                flex-direction: column;
            }
            
            .form-section, .list-section {
                min-width: auto;
            }
        }
    </style>
    <script>
        function afficherInfoExemplaire() {
            var select = document.getElementById('exemplaireId');
            var infoDiv = document.getElementById('exemplaireInfo');
            
            if (select.value) {
                var selectedOption = select.options[select.selectedIndex];
                var titre = selectedOption.getAttribute('data-titre');
                var auteur = selectedOption.getAttribute('data-auteur');
                var ageMin = selectedOption.getAttribute('data-age-min');
                
                infoDiv.innerHTML = 
                    '<h4>Informations sur le livre</h4>' +
                    '<p><strong>Titre:</strong> ' + titre + '</p>' +
                    '<p><strong>Auteur:</strong> ' + auteur + '</p>' +
                    '<p><strong>Âge minimum:</strong> ' + ageMin + ' ans</p>';
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }
        
        function afficherInfoAdherant() {
            var select = document.getElementById('adherantId');
            var infoDiv = document.getElementById('adherantInfo');
            
            if (select.value) {
                var selectedOption = select.options[select.selectedIndex];
                var nom = selectedOption.getAttribute('data-nom');
                var prenom = selectedOption.getAttribute('data-prenom');
                var quotaRestant = selectedOption.getAttribute('data-quota');
                
                infoDiv.innerHTML = 
                    '<h4>Informations sur l\'adhérant</h4>' +
                    '<p><strong>Nom:</strong> ' + nom + ' ' + prenom + '</p>' +
                    '<p><strong>Quota restant:</strong> ' + quotaRestant + ' emprunt(s)</p>';
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <h1>Prêter un livre</h1>
    </div>
    
    <div class="container">
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
        
        <div class="content-wrapper">
            <!-- Section formulaire -->
            <div class="form-section">
                <div class="form-container">
                    <h2>Nouveau prêt</h2>
                    <form method="post" action="/prets/preter">
                        <div class="form-group">
                            <label for="adherantId">Sélectionner un adhérant *</label>
                            <select id="adherantId" name="adherantId" required onchange="afficherInfoAdherant()">
                                <option value="">-- Choisir un adhérant --</option>
                                <c:forEach var="adherant" items="${adherants}">
                                    <option value="${adherant.id}" 
                                            data-nom="${adherant.nom}" 
                                            data-prenom="${adherant.prenom}"
                                            data-quota="${adherant.quotaRestantEmprunt}">
                                        ${adherant.nom} ${adherant.prenom} (${adherant.email})
                                    </option>
                                </c:forEach>
                            </select>
                            <div id="adherantInfo" class="exemplaire-info" style="display: none;"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="exemplaireId">Sélectionner un exemplaire *</label>
                            <select id="exemplaireId" name="exemplaireId" required onchange="afficherInfoExemplaire()">
                                <option value="">-- Choisir un exemplaire --</option>
                                <c:forEach var="exemplaire" items="${exemplaires}">
                                    <option value="${exemplaire.id}" 
                                            data-titre="${exemplaire.livre.titre}" 
                                            data-auteur="${exemplaire.livre.auteur}"
                                            data-age-min="${exemplaire.livre.ageMinimum}">
                                        ${exemplaire.livre.titre} - ${exemplaire.livre.auteur} (Exemplaire #${exemplaire.id})
                                    </option>
                                </c:forEach>
                            </select>
                            <div id="exemplaireInfo" class="exemplaire-info" style="display: none;"></div>
                        </div>
                        
                        <div class="form-group">
                            <label>Type de prêt *</label>
                            <div class="radio-group">
                                <label>
                                    <input type="radio" name="typePret" value="lecture_sur_place" required>
                                    Lecture sur place
                                </label>
                                <label>
                                    <input type="radio" name="typePret" value="a_emporter" required>
                                    À emporter
                                </label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button type="submit" class="btn">Prêter le livre</button>
                            <a href="/biblio/accueil" class="btn btn-secondary">Annuler</a>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Section liste des prêts -->
            <div class="list-section">
                <div class="list-container">
                    <h2>Prêts en cours</h2>
                    
                    <c:choose>
                        <c:when test="${not empty pretsActifs}">
                            <div class="prets-count">
                                ${pretsActifs.size()} prêt(s) en cours
                            </div>
                            
                            <table class="prets-table">
                                <thead>
                                    <tr>
                                        <th>Livre</th>
                                        <th>Adhérant</th>
                                        <th>Date prêt</th>
                                        <th>Date retour</th>
                                        <th>Type</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="pret" items="${pretsActifs}">
                                        <tr>
                                            <td>
                                                <strong>${pret.exemplaire.livre.titre}</strong><br>
                                                <small>${pret.exemplaire.livre.auteur}</small>
                                            </td>
                                            <td>
                                                ${pret.adherant.nom} ${pret.adherant.prenom}
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${pret.datePret}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <span class="date-retour ${pret.dateRetourPrevue.isBefore(java.time.LocalDate.now()) ? 'retard' : 'normal'}">
                                                    <fmt:formatDate value="${pret.dateRetourPrevue}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="type-pret ${pret.typePret == 'A_EMPORTER' ? 'type-emporter' : 'type-sur-place'}">
                                                    ${pret.typePret == 'A_EMPORTER' ? 'À emporter' : 'Sur place'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="no-prets">
                                Aucun prêt en cours
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <div class="back-link">
            <a href="/biblio/accueil">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>