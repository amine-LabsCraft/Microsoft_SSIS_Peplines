/* =====================================================================
   SSIS Pipelines - Script 00 : create the source database GestionDB
   Target   : SQL Server Express  (.\SQLEXPRESS)  - SSMS or VS Code (MSSQL)
   Content  : 5 tables (Produit, Vendeur, Region, Commande, LigneCommande)
              + the exact rows used by the 5 SSIS packages.
   Re-runnable: drops and recreates GestionDB.
   ===================================================================== */

USE master;
GO

IF DB_ID('GestionDB') IS NOT NULL
BEGIN
    ALTER DATABASE GestionDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GestionDB;
END
GO

CREATE DATABASE GestionDB;
GO

USE GestionDB;
GO

/* ---------------------------------------------------------------------
   Tables
   NCHAR(n) is fixed length: values are right-padded with spaces.
   This is why the Conditional Split uses TRIM(category).
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Produit (
    prod_id    NCHAR(10)  NOT NULL CONSTRAINT PK_Produit PRIMARY KEY,
    prod_name  NCHAR(100) NULL,
    category   NCHAR(30)  NULL
);

CREATE TABLE dbo.Vendeur (
    emp_id     NCHAR(10)  NOT NULL CONSTRAINT PK_Vendeur PRIMARY KEY,
    emp_name   NCHAR(40)  NULL
);

CREATE TABLE dbo.Region (
    reg_id     NCHAR(10)  NOT NULL CONSTRAINT PK_Region PRIMARY KEY,
    reg_name   NCHAR(20)  NULL
);

CREATE TABLE dbo.Commande (
    ord_id     NUMERIC(10,0) NOT NULL CONSTRAINT PK_Commande PRIMARY KEY,
    emp_id     NCHAR(10)     NULL CONSTRAINT FK_Commande_Vendeur REFERENCES dbo.Vendeur(emp_id),
    reg_id     NCHAR(10)     NULL CONSTRAINT FK_Commande_Region  REFERENCES dbo.Region(reg_id),
    ord_date   DATE          NULL
);

CREATE TABLE dbo.LigneCommande (
    ord_id     NUMERIC(10,0) NOT NULL CONSTRAINT FK_LigneCommande_Commande REFERENCES dbo.Commande(ord_id),
    prod_id    NCHAR(10)     NOT NULL CONSTRAINT FK_LigneCommande_Produit  REFERENCES dbo.Produit(prod_id),
    quantity   NUMERIC(2,0)  NULL,
    unit_price NUMERIC(10,0) NULL,
    CONSTRAINT PK_LigneCommande PRIMARY KEY (ord_id, prod_id)
);
GO

/* ---------------------------------------------------------------------
   Data
   --------------------------------------------------------------------- */
INSERT INTO dbo.Produit (prod_id, prod_name, category) VALUES
 (N'P01', N'Ordinateur portable',   N'Informatique'),
 (N'P02', N'Souris sans fil',       N'Informatique'),
 (N'P03', N'Clavier mecanique',     N'Informatique'),
 (N'P04', N'Ecran 24 pouces',       N'Informatique'),
 (N'P05', N'Bureau en bois',        N'Mobilier'),
 (N'P06', N'Chaise de bureau',      N'Mobilier'),
 (N'P07', N'Armoire de rangement',  N'Mobilier'),
 (N'P08', N'Ramette de papier',     N'Fournitures'),
 (N'P09', N'Boite de stylos',       N'Fournitures'),
 (N'P10', N'Cahier grand format',   N'Fournitures');

INSERT INTO dbo.Vendeur (emp_id, emp_name) VALUES
 (N'E01', N'Youssef Alami'),
 (N'E02', N'Salma Bennani'),
 (N'E03', N'Omar Idrissi'),
 (N'E04', N'Imane Alaoui'),
 (N'E05', N'Hamza El Amrani'),
 (N'E06', N'Sara Chraibi'),
 (N'E07', N'Mehdi Tazi'),
 (N'E08', N'Lina Naciri'),
 (N'E09', N'Ayoub Berrada'),
 (N'E10', N'Nour Fassi');

INSERT INTO dbo.Region (reg_id, reg_name) VALUES
 (N'R01', N'Casablanca-Settat'),
 (N'R02', N'Rabat-Sale'),
 (N'R03', N'Marrakech-Safi'),
 (N'R04', N'Fes-Meknes'),
 (N'R05', N'Tanger-Tetouan'),
 (N'R06', N'Souss-Massa'),
 (N'R07', N'Beni Mellal'),
 (N'R08', N'Oriental'),
 (N'R09', N'Draa-Tafilalet'),
 (N'R10', N'Guelmim');

INSERT INTO dbo.Commande (ord_id, emp_id, reg_id, ord_date) VALUES
 (1,  N'E01', N'R01', '2025-01-05'),
 (2,  N'E02', N'R02', '2025-01-08'),
 (3,  N'E03', N'R03', '2025-01-12'),
 (4,  N'E04', N'R04', '2025-01-18'),
 (5,  N'E05', N'R05', '2025-02-03'),
 (6,  N'E06', N'R06', '2025-02-10'),
 (7,  N'E07', N'R07', '2025-02-16'),
 (8,  N'E08', N'R08', '2025-03-01'),
 (9,  N'E09', N'R09', '2025-03-09'),
 (10, N'E10', N'R10', '2025-03-15');

INSERT INTO dbo.LigneCommande (ord_id, prod_id, quantity, unit_price) VALUES
 (1,  N'P01', 1,  7200),
 (2,  N'P02', 3,  180),
 (2,  N'P03', 1,  650),
 (3,  N'P04', 2,  1850),
 (3,  N'P08', 5,  65),
 (3,  N'P09', 2,  45),
 (4,  N'P05', 1,  2400),
 (5,  N'P06', 4,  1350),
 (5,  N'P10', 10, 38),
 (6,  N'P01', 1,  7200),
 (6,  N'P02', 2,  180),
 (6,  N'P08', 3,  65),
 (7,  N'P07', 1,  3200),
 (7,  N'P09', 6,  45),
 (8,  N'P03', 2,  650),
 (9,  N'P04', 1,  1850),
 (9,  N'P06', 2,  1350),
 (9,  N'P10', 8,  38),
 (10, N'P01', 2,  7200),
 (10, N'P05', 1,  2400);
GO

/* Quick check: 10 / 10 / 10 / 10 / 20 rows */
SELECT 'Produit' AS table_name, COUNT(*) AS nb_rows FROM dbo.Produit
UNION ALL SELECT 'Vendeur',       COUNT(*) FROM dbo.Vendeur
UNION ALL SELECT 'Region',        COUNT(*) FROM dbo.Region
UNION ALL SELECT 'Commande',      COUNT(*) FROM dbo.Commande
UNION ALL SELECT 'LigneCommande', COUNT(*) FROM dbo.LigneCommande;
GO
