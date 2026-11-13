/* =====================================================================
   TP2 SSIS - Script 00 : Vérifier la base source GestionDB
   A exécuter AVANT de commencer, dans VS Code (MSSQL -> localhost\SQLEXPRESS)
   Raccourci : Ctrl+Shift+E
   Ce script ne modifie rien : il lit seulement.
   ===================================================================== */

USE GestionDB;
GO

-- 1) Les tables existent-elles et contiennent-elles des données ?
SELECT 'Produit' AS table_name, COUNT(*) AS nb_lignes, 10 AS attendu FROM dbo.Produit
UNION ALL SELECT 'Vendeur',       COUNT(*), 10 FROM dbo.Vendeur
UNION ALL SELECT 'Region',        COUNT(*), 10 FROM dbo.Region
UNION ALL SELECT 'Commande',      COUNT(*), 10 FROM dbo.Commande
UNION ALL SELECT 'LigneCommande', COUNT(*), 20 FROM dbo.LigneCommande;
GO

-- 2) Les catégories de produits (utile pour le Conditional Split, Phase 3 - 7)
SELECT DISTINCT RTRIM(category) AS categorie FROM dbo.Produit ORDER BY categorie;
GO

-- 3) Preuve du "piège des espaces" : NCHAR(30) complète la valeur par des espaces
SELECT TOP 1
       '[' + category + ']'        AS valeur_brute,     -- [Informatique                  ]
       '[' + RTRIM(category) + ']' AS valeur_rtrim,     -- [Informatique]
       DATALENGTH(category)        AS octets_stockes    -- 60 octets = 30 caractères Unicode
FROM dbo.Produit;
GO

-- 4) La base DataDW (TP précédent) existe-t-elle ? (2e gestionnaire de connexions)
SELECT name AS base_trouvee FROM sys.databases WHERE name IN ('GestionDB', 'DataDW');
GO
