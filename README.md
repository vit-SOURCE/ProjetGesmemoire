# GesMemoires — UATM GASA Formation

Plateforme web de gestion des mémoires académiques développée pour l'UATM GASA Formation.

## Stack technique
React 19 + TypeScript + Vite + Tailwind CSS + Google Gemini AI

## Fonctionnalités
- 3 types de comptes : Étudiant non diplômé, Étudiant diplômé, Maître de mémoire
- Système d'inscription avec vérification d'identité par matricule (ETUxxx / PROxxx)
- Soumission et suivi de mémoires avec statuts (en attente, accepté, rejeté)
- Dashboard Directeur des Études pour validation des inscriptions et mémoires
- Dashboard Étudiant pour soumission et suivi en temps réel
- Dashboard Professeur avec gestion des spécialités et encadrements
- Lecteur de mémoires intégré
- Chat interne et assistant IA intégré (Google Gemini)
- Génération de PDF
- Données localisées : noms béninois, filières béninoises, emails @uatmgasa.bj

## Sécurité
- Vérification des matricules à l'inscription pour éviter les inscriptions frauduleuses
- Validation côté client sur tous les formulaires
- Système de validation par le Directeur des Études avant activation des comptes

## Lancer le projet en local
node -v && npm -v   # vérifier Node.js
npm install         # installer les dépendances
npm run dev         # lancer sur http://localhost:3000
REALISE PAR NICOUE KOUETE 
