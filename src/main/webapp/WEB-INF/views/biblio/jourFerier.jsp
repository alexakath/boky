<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des jours fériés - Bibliothèque</title>
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
            max-width: 1000px;
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
        
        input[type="date"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .btn {
            background-color: #FF9800;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn:hover {
            background-color: #e68900;
        }
        
        .btn-danger {
            background-color: #f44336;
        }
        
        .btn-danger:hover {
            background-color: #da190b;
        }
        
        .btn-small {
            padding: 8px 12px;
            font-size: 14px;
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
        
        .table-section {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
            background-color: #f8f9fa;
            font-weight: bold;
            color: #333;
        }
        
        tr:hover {
            background-color: #f8f9fa;
        }
        
        .no-data {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 20px;
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
        <h1>Gestion des jours fériés</h1>
    </div>
    
    <div class="container">
        <!-- Formulaire d'ajout -->
        <div class="form-section">
            <h2>Ajouter un jour férié</h2>
            
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
            
            <form action="/jours-feries/ajouter" method="POST">
                <div class="form-group">
                    <label for="dateFerier">Date du jour férié :</label>
                    <input type="date" id="dateFerier" name="dateFerier" 
                           value="${dateFerier}" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description :</label>
                    <textarea id="description" name="description" 
                              placeholder="Ex: Nouvel An, Fête nationale, etc." required>${description}</textarea>
                </div>
                
                <button type="submit" class="btn">Enregistrer</button>
            </form>
        </div>
        
        <!-- Liste des jours fériés -->
        <div class="table-section">
            <h2>Liste des jours fériés</h2>
            
            <c:choose>
                <c:when test="${not empty joursFeries}">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="jour" items="${joursFeries}">
                                <tr>
                                    <td>
                                        ${jour.dateFerier}"
                                    </td>
                                    <td>${jour.description}</td>
                                    <td>
                                        <form action="/jours-feries/supprimer/${jour.id}" method="POST" 
                                              style="display: inline;"
                                              onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce jour férié ?');">
                                            <button type="submit" class="btn btn-danger btn-small">
                                                Supprimer
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
                        Aucun jour férié enregistré.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="back-link">
            <a href="/accueil">← Retour à l'accueil bibliothécaire</a>
        </div>
    </div>
</body>
</html>