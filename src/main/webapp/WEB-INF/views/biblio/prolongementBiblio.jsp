<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Prolongements - Bibliothèque</title>
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
            border-bottom: 2px solid #FF9800;
            padding-bottom: 10px;
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
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 2px;
            font-size: 14px;
            transition: background-color 0.3s;
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
        
        .info-text {
            color: #666;
            font-style: italic;
            margin-top: 10px;
            text-align: center;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            border-radius: 10px;
            width: 50%;
            max-width: 500px;
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: black;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
            min-height: 80px;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>Gestion des Prolongements</h1>
            <a href="/accueil" class="back-btn">Retour à l'accueil</a>
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
        
        <!-- Liste des demandes de prolongement -->
        <div class="card">
            <h2>Demandes de prolongement en attente</h2>
            
            <c:choose>
                <c:when test="${empty demandesEnAttente}">
                    <p class="info-text">Aucune demande de prolongement en attente.</p>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Adhérant</th>
                                <th>Livre</th>
                                <th>Date d'emprunt</th>
                                <th>Date de retour actuelle</th>
                                <th>Nouvelle date souhaitée</th>
                                <th>Date de demande</th>
                                <th>Prolongements effectués</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="demande" items="${demandesEnAttente}">
                                <tr>
                                    <td>
                                        ${demande.pret.adherant.nom} ${demande.pret.adherant.prenom}
                                    </td>
                                    <td>
                                        ${demande.pret.exemplaire.livre.titre}<br>
                                        <small>par ${demande.pret.exemplaire.livre.auteur}</small>
                                    </td>
                                    <td>${demande.pret.datePret}</td>
                                    <td>${demande.pret.dateRetourPrevue}</td>
                                    <td>${demande.nouvelleDateRetour}</td>
                                    <td>${demande.dateDemande}</td>
                                    <td>${demande.pret.nombreProlongements}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <form method="post" action="/prolongements/valider" style="display: inline;">
                                                <input type="hidden" name="idDemande" value="${demande.id}">
                                                <button type="submit" class="btn btn-success" 
                                                        onclick="return confirm('Êtes-vous sûr de vouloir valider cette demande ?')">
                                                    Valider
                                                </button>
                                            </form>
                                            
                                            <button type="button" class="btn btn-danger" 
                                                    onclick="openRejectModal('${demande.id}')">
                                                Rejeter
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- Modal pour le rejet avec motif -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeRejectModal()">&times;</span>
            <h3>Rejeter la demande de prolongement</h3>
            <form method="post" action="/prolongements/rejeter">
                <input type="hidden" id="rejectDemandeId" name="idDemande">
                <div class="form-group">
                    <label for="motifRefus">Motif du refus :</label>
                    <textarea id="motifRefus" name="motifRefus" required 
                              placeholder="Veuillez indiquer le motif du refus de cette demande de prolongement..."></textarea>
                </div>
                <div class="action-buttons">
                    <button type="submit" class="btn btn-danger">Rejeter</button>
                    <button type="button" class="btn" onclick="closeRejectModal()">Annuler</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openRejectModal(demandeId) {
            document.getElementById('rejectDemandeId').value = demandeId;
            document.getElementById('rejectModal').style.display = 'block';
        }
        
        function closeRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
            document.getElementById('motifRefus').value = '';
        }
        
        // Fermer le modal si on clique à l'extérieur
        window.onclick = function(event) {
            var modal = document.getElementById('rejectModal');
            if (event.target == modal) {
                closeRejectModal();
            }
        }
    </script>
</body>
</html>