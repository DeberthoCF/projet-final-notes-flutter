import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'interfaces/accueil_interface.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AccueilInterface(),
    );
  }
}
