import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'connexion_interface.dart';
import 'inscription_interface.dart';

class AccueilInterface extends StatelessWidget {
  const AccueilInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/notes_.png',
                height: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const Text(
                'NoteFlow',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bleuNuit,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Vos idées, organisées simplement.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppTheme.texteFonce),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConnexionInterface(),
                      ),
                    );
                  },
                  child: const Text('Se connecter'),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Pas encore inscrit ?',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InscriptionInterface(),
                      ),
                    );
                  },
                  child: const Text('Créer un compte'),
                ),
              ),

              const Spacer(),

              const Text(
                'Vos données restent enregistrées localement.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
