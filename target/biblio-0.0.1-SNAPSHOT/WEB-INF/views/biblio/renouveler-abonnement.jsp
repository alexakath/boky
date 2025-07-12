<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Renouveler un Abonnement</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .adherant-info {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Gestion des Abonnements</h1>
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3>Renouveler un Abonnement</h3>
                    </div>
                    <div class="card-body">
                        <!-- Messages d'erreur et de succès -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                ${success}
                            </div>
                        </c:if>

                        <!-- Formulaire de renouvellement -->
                        <form method="POST" action="/abonnements/renouveler">
                            <div class="mb-3">
                                <label for="adherantId" class="form-label">Référence de l'Adhérant <span class="text-danger">*</span></label>
                                <select class="form-select" id="adherantId" name="adherantId" required onchange="loadAdherantDetails()">
                                    <option value="">Sélectionnez un adhérant</option>
                                    <c:forEach var="adherant" items="${adherants}">
                                        <option value="${adherant.id}" 
                                                <c:if test="${adherant.id == adherantId}">selected</c:if>>
                                            ${adherant.id} - ${adherant.prenom} ${adherant.nom}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Zone d'affichage des détails de l'adhérant -->
                            <div id="adherantDetails" class="adherant-info" style="display: none;">
                                <strong>Détails de l'adhérant :</strong>
                                <div id="adherantInfo"></div>
                            </div>

                            <div class="mb-3">
                                <label for="nouvelleDateFin" class="form-label">Nouvelle Date de Début d'Abonnement <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="nouvelleDateFin" name="nouvelleDateFin" 
                                       value="${nouvelleDateFin}" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Renouveler</button>
                                <a href="/accueil" class="btn btn-secondary">Retour au Menu</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des adhérants pour référence -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5>Liste des Adhérants</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Email</th>
                                        <th>Type</th>
                                        <th>Abonnements</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="adherant" items="${adherants}">
                                        <tr>
                                            <td>${adherant.id}</td>
                                            <td>${adherant.nom}</td>
                                            <td>${adherant.prenom}</td>
                                            <td>${adherant.email}</td>
                                            <td>${adherant.typeAdherant.nomType}</td>
                                            <td>
                                                <c:forEach var="abonnement" items="${adherant.abonnements}">
                                                    ${abonnement.dateDebut} → ${abonnement.dateFin}<br>
                                                </c:forEach>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function loadAdherantDetails() {
            const adherantId = document.getElementById('adherantId').value;
            const detailsDiv = document.getElementById('adherantDetails');
            const infoDiv = document.getElementById('adherantInfo');
            
            if (adherantId) {
                fetch('/abonnements/details/' + adherantId)
                    .then(response => response.text())
                    .then(data => {
                        infoDiv.innerHTML = data;
                        detailsDiv.style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Erreur:', error);
                        infoDiv.innerHTML = 'Erreur lors du chargement des détails';
                        detailsDiv.style.display = 'block';
                    });
            } else {
                detailsDiv.style.display = 'none';
            }
        }

        // Définir la date minimum à aujourd'hui
        document.getElementById('nouvelleDateFin').min = new Date().toISOString().split('T')[0];
    </script>
</body>
</html>