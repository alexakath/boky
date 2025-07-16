<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        
        h1 {
            margin: 0;
            font-size: 28px;
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
            box-sizing: border-box;
        }
        
        .btn {
            background-color: #2196F3;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        
        .btn:hover {
            background-color: #1976D2;
        }
        
        .btn-secondary {
            background-color: #666;
        }
        
        .btn-secondary:hover {
            background-color: #555;
        }
        
        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
        }
        
        .success-message {
            background-color: #e8f5e8;
            color: #2e7d32;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #4caf50;
        }
        
        .table-container {
            overflow-x: auto;
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
            background-color: #f5f5f5;
            font-weight: bold;
        }
        
        tr:hover {
            background-color: #f9f9f9;
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
        
        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 10px;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .radio-option input[type="radio"] {
            width: auto;
        }
        
        .info-box {
            background-color: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .info-box h3 {
            margin: 0 0 10px 0;
            color: #1976D2;
        }
        
        .info-box ul {
            margin: 0;
            padding-left: 20px;
        }
        
        .date-info {
            background-color: #fff3e0;
            border-left: 4px solid #FF9800;
            padding: 10px;
            margin-top: 5px;
            font-size: 14px;
            color: #e65100;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            align-items: end;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .today-btn {
            background-color: #FF9800;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            height: 42px;
        }
        
        .today-btn:hover {
            background-color: #F57C00;
        }
        
        .loading {
            display: none;
            color: #666;
            font-style: italic;
        }
        
        .type-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .adherant-info {
            background-color: #e8f5e8;
            border-left: 4px solid #4caf50;
            padding: 10px;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
    <script>
        function setTodayDate() {
            const today = new Date();
            const todayString = today.toISOString().split('T')[0];
            document.getElementById('datePret').value = todayString;
            calculateReturnDate();
        }
        
        function calculateReturnDate() {
            const datePretInput = document.getElementById('datePret');
            const idAdherantInput = document.getElementById('idAdherant');
            const typePretRadios = document.getElementsByName('typePret');
            const dateInfoDiv = document.getElementById('dateInfo');
            const loadingDiv = document.getElementById('loading');
            
            if (!datePretInput.value) {
                dateInfoDiv.innerHTML = 'Veuillez sélectionner une date de prêt.';
                return;
            }
            
            if (!idAdherantInput.value) {
                dateInfoDiv.innerHTML = 'Veuillez saisir l\'ID de l\'adhérant.';
                return;
            }
            
            let typePret = '';
            for (let radio of typePretRadios) {
                if (radio.checked) {
                    typePret = radio.value;
                    break;
                }
            }
            
            if (!typePret) {
                dateInfoDiv.innerHTML = 'Veuillez sélectionner un type de prêt.';
                return;
            }
            
            // Afficher le loading
            loadingDiv.style.display = 'block';
            dateInfoDiv.innerHTML = '';
            
            // Appel AJAX pour calculer la date de retour
            const xhr = new XMLHttpRequest();
            xhr.open('GET', '/prets/calculer-date-retour?idAdherant=' + 
                     encodeURIComponent(idAdherantInput.value) + 
                     '&datePret=' + encodeURIComponent(datePretInput.value) + 
                     '&typePret=' + encodeURIComponent(typePret));
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    loadingDiv.style.display = 'none';
                    
                    if (xhr.status === 200) {
                        const dateRetour = xhr.responseText;
                        
                        if (dateRetour === 'error') {
                            dateInfoDiv.innerHTML = '<span style="color: #d32f2f;">Erreur lors du calcul de la date de retour. Vérifiez l\'ID de l\'adhérant.</span>';
                        } else {
                            const dateRetourObj = new Date(dateRetour);
                            const datePretObj = new Date(datePretInput.value);
                            
                            if (typePret === 'LECTURE_SUR_PLACE') {
                                dateInfoDiv.innerHTML = '<strong>Date de retour prévue :</strong> ' + 
                                                      dateRetourObj.toLocaleDateString('fr-FR') + 
                                                      ' <em>(même jour - lecture sur place)</em>';
                            } else {
                                const diffTime = Math.abs(dateRetourObj - datePretObj);
                                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                                
                                dateInfoDiv.innerHTML = '<strong>Date de retour prévue :</strong> ' + 
                                                      dateRetourObj.toLocaleDateString('fr-FR') + 
                                                      ' <em>(' + diffDays + ' jour(s) après le prêt selon le type d\'adhérant)</em>';
                            }
                        }
                    } else {
                        dateInfoDiv.innerHTML = '<span style="color: #d32f2f;">Erreur de communication avec le serveur.</span>';
                    }
                }
            };
            
            xhr.send();
        }
        
        // Initialiser la date d'aujourd'hui au chargement de la page
        window.onload = function() {
            setTodayDate();
        };
    </script>
</head>
<body>
    <div class="header">
        <h1>Prêter un livre</h1>
    </div>
    
    <div class="container">
        <div class="info-box">
            <h3>Règles de prêt</h3>
            <ul>
                <li>L'adhérant doit avoir un abonnement valide</li>
                <li>L'adhérant ne doit pas avoir de pénalité active</li>
                <li>L'exemplaire doit être disponible</li>
                <li>Le quota d'emprunts ne doit pas être dépassé</li>
                <li>L'âge de l'adhérant doit être compatible avec le livre</li>
                <li>Lecture sur place : retour le même jour</li>
                <li>À emporter : durée selon le type d'adhérant (Étudiant: 7j, Enseignant: 9j, Professionnel: 12j)</li>
                <li><strong>Nouvelle fonctionnalité :</strong> Vous pouvez saisir manuellement la date de prêt (antérieure ou postérieure à aujourd'hui)</li>
            </ul>
        </div>
        
        <div class="form-section">
            <h2>Nouveau prêt</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form method="post" action="/prets/preter">
                <div class="form-group">
                    <label for="idAdherant">ID Adhérant :</label>
                    <input type="number" id="idAdherant" name="idAdherant" required 
                           placeholder="Entrez l'ID de l'adhérant" min="1" 
                           onchange="calculateReturnDate()" onblur="calculateReturnDate()">
                </div>
                
                <div class="form-group">
                    <label for="idExemplaire">ID Exemplaire :</label>
                    <input type="number" id="idExemplaire" name="idExemplaire" required 
                           placeholder="Entrez l'ID de l'exemplaire" min="1">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="datePret">Date de prêt :</label>
                        <input type="date" id="datePret" name="datePret" required 
                               onchange="calculateReturnDate()">
                    </div>
                    <button type="button" class="today-btn" onclick="setTodayDate()">
                        Aujourd'hui
                    </button>
                </div>
                
                <div class="form-group">
                    <label>Type de prêt :</label>
                    <div class="radio-group">
                        <div class="radio-option">
                            <input type="radio" id="lecture_sur_place" name="typePret" 
                                   value="LECTURE_SUR_PLACE" required onchange="calculateReturnDate()">
                            <label for="lecture_sur_place">Lecture sur place</label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="a_emporter" name="typePret" 
                                   value="A_EMPORTER" required onchange="calculateReturnDate()">
                            <label for="a_emporter">À emporter</label>
                        </div>
                    </div>
                </div>
                
                <div class="type-info">
                    <strong>Durées de prêt par type d'adhérant :</strong><br>
                    • Étudiant : 7 jours<br>
                    • Enseignant : 9 jours<br>
                    • Professionnel : 12 jours<br>
                    • Lecture sur place : même jour
                </div>
                
                <div id="loading" class="loading">
                    Calcul de la date de retour en cours...
                </div>
                
                <div class="date-info" id="dateInfo">
                    <!-- Les informations de date de retour seront affichées ici -->
                </div>
                
                <div style="margin-top: 20px;">
                    <button type="submit" class="btn">Prêter</button>
                    <button type="reset" class="btn btn-secondary" onclick="setTodayDate()">Réinitialiser</button>
                </div>
            </form>
        </div>
        
        <div class="form-section">
            <h2>Prêts actifs</h2>
            
            <c:if test="${empty pretsActifs}">
                <p>Aucun prêt actif pour le moment.</p>
            </c:if>
            
            <c:if test="${not empty pretsActifs}">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID Prêt</th>
                                <th>Adhérant</th>
                                <th>Type Adhérant</th>
                                <th>Livre</th>
                                <th>Exemplaire</th>
                                <th>Date de prêt</th>
                                <th>Date de retour prévue</th>
                                <th>Type de prêt</th>
                                <th>Prolongements</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pret" items="${pretsActifs}">
                                <tr>
                                    <td>${pret.id}</td>
                                    <td>${pret.adherant.nom} ${pret.adherant.prenom}</td>
                                    <td>${pret.adherant.typeAdherant.nomType}</td>
                                    <td>${pret.exemplaire.livre.titre}</td>
                                    <td>${pret.exemplaire.id}</td>
                                    <td>${pret.datePret}</td>
                                    <td>${pret.dateRetourPrevue}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${pret.typePret == 'LECTURE_SUR_PLACE'}">
                                                Lecture sur place
                                            </c:when>
                                            <c:otherwise>
                                                À emporter
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${pret.nombreProlongements}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil</a>
        </div>
    </div>
</body>
</html>