import 'package:flutter/material.dart';

import '../services/auth_utils.dart';
import '../services/database_manager.dart';
import '../theme/app_theme.dart';
import 'notes_interface.dart';

class ConnexionInterface extends StatefulWidget {
  const ConnexionInterface({super.key});

  @override
  State<ConnexionInterface> createState() => _ConnexionInterfaceState();
}

class _ConnexionInterfaceState extends State<ConnexionInterface> {
  final TextEditingController _nomController = TextEditingController();

  final TextEditingController _motDePasseController = TextEditingController();

  final DatabaseManager _databaseManager = DatabaseManager();

  bool _motDePasseVisible = false;

  Future<void> _seConnecter() async {
    final nom = _nomController.text.trim();
    final motDePasse = _motDePasseController.text.trim();

    if (nom.isEmpty || motDePasse.isEmpty) {
      _afficherErreur('Veuillez remplir tous les champs.');
      return;
    }

    final utilisateur = await _databaseManager.connecterUtilisateur(
      nom,
      hacherMotDePasse(motDePasse),
    );

    if (!mounted) return;

    if (utilisateur == null) {
      _afficherErreur("Nom d'utilisateur ou mot de passe incorrect.");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotesInterface(utilisateur: utilisateur),
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                Image.asset(
                  'assets/images/notes_.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                const Text(
                  'NoteFlow',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bleuNuit,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Vos idées, organisées simplement.',
                  style: TextStyle(fontSize: 16, color: AppTheme.texteFonce),
                ),

                const SizedBox(height: 40),

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
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _motDePasseVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),

                      onPressed: () {
                        setState(() {
                          _motDePasseVisible = !_motDePasseVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _seConnecter,
                    child: const Text('Connexion'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
