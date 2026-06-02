-- ============================================================
--  GesMemoires — Script de création de base de données
--  UATM GASA — Programme OE/SIL-IUT
--  Version 3.0 — Mai 2026
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `Gesmemoires`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `Gesmemoires`;

-- ------------------------------------------------------------
-- Table : utilisateur (table parente)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE `utilisateur` (
  `id_utilisateur` INT          NOT NULL AUTO_INCREMENT,
  `nom`            VARCHAR(100) NOT NULL,
  `prenom`         VARCHAR(100) NOT NULL,
  `email`          VARCHAR(150) NOT NULL UNIQUE,
  `password`       VARCHAR(255) NOT NULL,
  `role`           ENUM('etudiant', 'professeur', 'de') NOT NULL,
  PRIMARY KEY (`id_utilisateur`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : filiere
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `filiere`;
CREATE TABLE `filiere` (
  `id_filiere`  INT          NOT NULL AUTO_INCREMENT,
  `nom`         VARCHAR(100) NOT NULL,
  `description` TEXT,
  PRIMARY KEY (`id_filiere`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : etudiant (hérite de utilisateur)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE `etudiant` (
  `id_utilisateur` INT         NOT NULL,
  `Etu_matricule`  VARCHAR(20) NOT NULL UNIQUE,
  `type`           ENUM('diplome', 'non_diplome') NOT NULL,
  `statut`         ENUM('en_attente', 'actif', 'inactif') NOT NULL DEFAULT 'en_attente',
  `id_filiere`     INT         DEFAULT NULL,
  PRIMARY KEY (`Etu_matricule`),
  CONSTRAINT `fk_etudiant_utilisateur` FOREIGN KEY (`id_utilisateur`)
    REFERENCES `utilisateur`(`id_utilisateur`) ON DELETE CASCADE,
  CONSTRAINT `fk_etudiant_filiere` FOREIGN KEY (`id_filiere`)
    REFERENCES `filiere`(`id_filiere`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : professeur (hérite de utilisateur)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `professeur`;
CREATE TABLE `professeur` (
  `id_utilisateur`    INT         NOT NULL,
  `Prof_matricule`    VARCHAR(20) NOT NULL UNIQUE,
  `est_maitre_memoire` BOOLEAN    NOT NULL DEFAULT FALSE,
  `statut`            ENUM('en_attente', 'actif', 'inactif') NOT NULL DEFAULT 'en_attente',
  PRIMARY KEY (`Prof_matricule`),
  CONSTRAINT `fk_professeur_utilisateur` FOREIGN KEY (`id_utilisateur`)
    REFERENCES `utilisateur`(`id_utilisateur`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : de (hérite de utilisateur)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `de`;
CREATE TABLE `de` (
  `id_utilisateur` INT         NOT NULL,
  `DE_matricule`   VARCHAR(20) NOT NULL UNIQUE,
  `bureau`         VARCHAR(100) DEFAULT NULL,
  `telephone`      VARCHAR(20)  DEFAULT NULL,
  PRIMARY KEY (`DE_matricule`),
  CONSTRAINT `fk_de_utilisateur` FOREIGN KEY (`id_utilisateur`)
    REFERENCES `utilisateur`(`id_utilisateur`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : specialite
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `specialite`;
CREATE TABLE `specialite` (
  `id_specialite` INT          NOT NULL AUTO_INCREMENT,
  `libelle`       VARCHAR(150) NOT NULL UNIQUE,
  PRIMARY KEY (`id_specialite`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : expertise_maitre (association professeur <-> specialite)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `expertise_maitre`;
CREATE TABLE `expertise_maitre` (
  `Prof_matricule` VARCHAR(20) NOT NULL,
  `id_specialite`  INT         NOT NULL,
  PRIMARY KEY (`Prof_matricule`, `id_specialite`),
  CONSTRAINT `fk_expertise_professeur` FOREIGN KEY (`Prof_matricule`)
    REFERENCES `professeur`(`Prof_matricule`) ON DELETE CASCADE,
  CONSTRAINT `fk_expertise_specialite` FOREIGN KEY (`id_specialite`)
    REFERENCES `specialite`(`id_specialite`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table : memoire
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `memoire`;
CREATE TABLE `memoire` (
  `id_memoire`         INT          NOT NULL AUTO_INCREMENT,
  `titre`              VARCHAR(255) NOT NULL,
  `annee`              YEAR         NOT NULL,
  `fichier`            VARCHAR(255) NOT NULL,
  `statut`             ENUM('en_attente', 'en_correction', 'valide', 'rejete', 'archive') NOT NULL DEFAULT 'en_attente',
  `commentaire_maitre` TEXT         DEFAULT NULL,
  `date_envoi`         DATETIME     DEFAULT NULL,
  `date_publication`   DATETIME     DEFAULT NULL,
  `Etu_matricule`      VARCHAR(20)  DEFAULT NULL,
  `Prof_matricule`     VARCHAR(20)  DEFAULT NULL,
  `DE_matricule`       VARCHAR(20)  NOT NULL,
  PRIMARY KEY (`id_memoire`),
  CONSTRAINT `fk_memoire_etudiant`   FOREIGN KEY (`Etu_matricule`)
    REFERENCES `etudiant`(`Etu_matricule`)     ON DELETE SET NULL,
  CONSTRAINT `fk_memoire_professeur` FOREIGN KEY (`Prof_matricule`)
    REFERENCES `professeur`(`Prof_matricule`)  ON DELETE SET NULL,
  CONSTRAINT `fk_memoire_de`         FOREIGN KEY (`DE_matricule`)
    REFERENCES `de`(`DE_matricule`)            ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DONNÉES DE TEST (mot de passe : mdp123)
-- hash : password_hash('mdp123', PASSWORD_DEFAULT)
-- ============================================================

-- Filières
INSERT INTO `filiere` (`nom`, `description`) VALUES
('Informatique de gestion',  'Filière orientée gestion et systèmes d information'),
('Réseaux et systèmes',      'Filière orientée infrastructure et télécommunications'),
('Développement logiciel',   'Filière orientée programmation et génie logiciel');

-- Spécialités
INSERT INTO `specialite` (`libelle`) VALUES
('Intelligence Artificielle'),
('Réseaux & Télécommunications'),
('Développement Web'),
('Gestion de projet'),
('Bases de données');

-- Utilisateur DE (créé directement en BDD)
INSERT INTO `utilisateur` (`nom`, `prenom`, `email`, `password`, `role`) VALUES
('LITCHEOU', 'Princesse', 'de@uatmgasa.bj', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'de');

INSERT INTO `de` (`id_utilisateur`, `DE_matricule`, `bureau`, `telephone`) VALUES
(1, 'de001', 'Bureau 101 - Bâtiment A', '+229 97000001');

-- Utilisateurs Professeur
INSERT INTO `utilisateur` (`nom`, `prenom`, `email`, `password`, `role`) VALUES
('AGNIDE',    'Vital',   'vital.agnide@uatmgasa.bj',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'professeur'),
('AZONDEKON', 'Fabrice', 'f.azondekon@uatmgasa.bj',     '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'professeur');

INSERT INTO `professeur` (`id_utilisateur`, `Prof_matricule`, `est_maitre_memoire`, `statut`) VALUES
(2, 'pro001', TRUE,  'actif'),
(3, 'pro002', FALSE, 'actif');

-- Expertise des professeurs
INSERT INTO `expertise_maitre` (`Prof_matricule`, `id_specialite`) VALUES
('pro001', 1),
('pro001', 5),
('pro002', 2),
('pro002', 3);

-- Utilisateurs Etudiants
INSERT INTO `utilisateur` (`nom`, `prenom`, `email`, `password`, `role`) VALUES
('PEDROS MARCOS', 'Samuel',  'samuel.pedros@etudiant.uatmgasa.bj',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'etudiant'),
('KPOSSOU',       'Ariane',  'ariane.kpossou@etudiant.uatmgasa.bj', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'etudiant'),
('GBAGUIDI',      'Mathieu', 'mathieu.gbaguidi@etudiant.uatmgasa.bj','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'etudiant');

INSERT INTO `etudiant` (`id_utilisateur`, `Etu_matricule`, `type`, `statut`, `id_filiere`) VALUES
(4, 'etu001', 'diplome',     'actif', 1),
(5, 'etu002', 'diplome',     'actif', 1),
(6, 'etu003', 'non_diplome', 'actif', 2);

-- Mémoires
INSERT INTO `memoire` (`titre`, `annee`, `fichier`, `statut`, `commentaire_maitre`, `date_envoi`, `date_publication`, `Etu_matricule`, `Prof_matricule`, `DE_matricule`) VALUES
(
  'Mise en place d un système de gestion hospitalière avec Java et PostgreSQL',
  2025,
  'uploads/etu001_horizon_sante.pdf',
  'valide',
  'Excellent travail. Bien structuré et documenté.',
  '2025-03-10 09:00:00',
  '2025-04-15 14:30:00',
  'etu001', 'pro001', 'de001'
),
(
  'Impact des réseaux sociaux sur l apprentissage des langues en milieu universitaire',
  2026,
  'uploads/etu002_reseaux_sociaux.pdf',
  'en_correction',
  'Revoir la méthodologie de recherche et enrichir la bibliographie.',
  '2026-05-01 10:00:00',
  NULL,
  'etu002', 'pro001', 'de001'
),
(
  'Conception d une application mobile de gestion de stock pour les PME béninoises',
  2024,
  'uploads/archive_gestion_stock_2024.pdf',
  'archive',
  NULL,
  NULL,
  '2024-06-20 08:00:00',
  NULL, NULL, 'de001'
);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
