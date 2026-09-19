import 'package:flutter/material.dart';

import '../modele/utilisateur.dart';
import '../services/auth_utils.dart';
import '../services/database_manager.dart';
import '../theme/app_theme.dart';
import 'notes_interface.dart';

class InscriptionInterface extends StatefulWidget {
  const InscriptionInterface({super.key});

  @override
  State<InscriptionInterface> createState() => _InscriptionInterfaceState();
}

class _InscriptionInterfaceState extends State<InscriptionInterface> {
  final _nomController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();

  final DatabaseManager _databaseManager = DatabaseManager();

  bool _motDePasseVisible = false;

  Future<void> _creerCompte() async {
    final nom = _nomController.text.trim();
    final motDePasse = _motDePasseController.text.trim();
    final confirmation = _confirmationController.text.trim();

    if (nom.isEmpty || motDePasse.isEmpty || confirmation.isEmpty) {
      _afficherErreur('Veuillez remplir tous les champs.');
      return;
    }

    if (motDePasse != confirmation) {
      _afficherErreur('Les mots de passe ne correspondent pas.');
      return;
    }

    final existe = await _databaseManager.nomUtilisateurExiste(nom);

    if (existe) {
      _afficherErreur("Ce nom d'utilisateur existe déjà.");
      return;
    }

    final utilisateur = Utilisateur.sansId(
      nomUtilisateur: nom,
      motDePasseHash: hacherMotDePasse(motDePasse),
    );

    final id = await _databaseManager.creerUtilisateur(utilisateur);

    if (!mounted) return;

    final utilisateurConnecte = Utilisateur(
      id: id,
      nomUtilisateur: nom,
      motDePasseHash: hacherMotDePasse(motDePasse),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotesInterface(utilisateur: utilisateurConnecte),
      ),
    );
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.corail),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _motDePasseController,
              obscureText: !_motDePasseVisible,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _confirmationController,
              obscureText: !_motDePasseVisible,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 16),

            CheckboxListTile(
              value: _motDePasseVisible,
              title: const Text('Afficher les mots de passe'),
              onChanged: (valeur) {
                setState(() {
                  _motDePasseVisible = valeur ?? false;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _creerCompte,
                child: const Text('Créer mon compte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
