/* =====================================================================
   TP2 SSIS - Script 99 : Résultats attendus, calculés en SQL
   Chaque bloc donne ce que le fichier produit par SSIS doit contenir.
   Comparez ligne à ligne avec vos fichiers .txt / .xlsx.
   ===================================================================== */

USE GestionDB;
GO

-- [PHASE 2 - 5] Package.dtsx -> Produits.txt : les 10 produits
SELECT prod_id, prod_name, category FROM dbo.Produit;
GO

-- [PHASE 3 - 6] Tri : catégorie CROISSANTE puis libellé DÉCROISSANT
SELECT RTRIM(prod_id) AS prod_id, RTRIM(prod_name) AS prod_name, RTRIM(category) AS category
FROM dbo.Produit
ORDER BY category ASC, prod_name DESC;
GO

-- [PHASE 3 - 7] Conditional Split : nombre de lignes attendu dans chaque fichier
SELECT RTRIM(category) AS fichier_categorie, COUNT(*) AS nb_lignes_attendues
FROM dbo.Produit
GROUP BY category
ORDER BY fichier_categorie;
GO

-- [PHASE 3 - 8] Aggregate : catégorie + nombre de produits
SELECT RTRIM(category) AS category, COUNT(prod_id) AS nb_produits
FROM dbo.Produit
GROUP BY category;
GO

-- [PHASE 3 - 9] Merge Join : les régions et leurs employés (via Commande)
SELECT RTRIM(r.reg_name) AS reg_name, RTRIM(v.emp_name) AS emp_name
FROM dbo.Commande c
JOIN dbo.Vendeur v ON v.emp_id = c.emp_id
JOIN dbo.Region  r ON r.reg_id = c.reg_id
ORDER BY r.reg_id;
GO
