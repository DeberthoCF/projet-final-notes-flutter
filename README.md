# NoteFlow

NoteFlow est une application mobile Android développée avec Flutter dans le cadre du projet final du niveau intermédiaire D-CLIC.

L'application permet à plusieurs utilisateurs de créer un compte, de se connecter et de gérer leurs notes personnelles. Les données sont enregistrées localement avec SQLite.

## Fonctionnalités

- Création d'un compte utilisateur
- Connexion avec nom d'utilisateur et mot de passe
- Hachage du mot de passe avant stockage
- Ajout de notes
- Affichage des notes de l'utilisateur connecté
- Modification d'une note
- Suppression d'une note avec confirmation
- Conservation locale des données avec SQLite
- Séparation des notes selon l'utilisateur
- Confirmation avant déconnexion
- Messages de validation et d'erreur
- Interface Material Design responsive et lisible

## Technologies utilisées

- Flutter
- Dart
- SQLite avec `sqflite 2.4.2`
- `path`
- `crypto`
- Material Design

## Structure principale

```text
lib/
├── main.dart
├── interfaces/
│   ├── accueil_interface.dart
│   ├── connexion_interface.dart
│   ├── inscription_interface.dart
│   ├── notes_interface.dart
│   └── note_editeur_interface.dart
├── modele/
│   ├── note.dart
│   └── utilisateur.dart
├── services/
│   ├── auth_utils.dart
│   └── database_manager.dart
└── theme/
    └── app_theme.dart
