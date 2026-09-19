import 'package:flutter/material.dart';

import '../modele/note.dart';
import '../services/database_manager.dart';

class NoteEditeurInterface extends StatefulWidget {
  final int utilisateurId;
  final Note? note;

  const NoteEditeurInterface({
    super.key,
    required this.utilisateurId,
    this.note,
  });

  @override
  State<NoteEditeurInterface> createState() => _NoteEditeurInterfaceState();
}

class _NoteEditeurInterfaceState extends State<NoteEditeurInterface> {
  final DatabaseManager _databaseManager = DatabaseManager();

  late TextEditingController _titreController;
  late TextEditingController _contenuController;

  @override
  void initState() {
    super.initState();

    _titreController = TextEditingController(text: widget.note?.titre ?? '');

    _contenuController = TextEditingController(
      text: widget.note?.contenu ?? '',
    );
  }

  Future<void> _enregistrerNote() async {
    final titre = _titreController.text.trim();
    final contenu = _contenuController.text.trim();

    if (titre.isEmpty || contenu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un titre et un contenu.'),
        ),
      );
      return;
    }

    final dateModification = DateTime.now().toIso8601String();

    if (widget.note == null) {
      final nouvelleNote = Note.sansId(
        utilisateurId: widget.utilisateurId,
        titre: titre,
        contenu: contenu,
        dateModification: dateModification,
      );

      await _databaseManager.insertNote(nouvelleNote);
    } else {
      final noteModifiee = Note(
        id: widget.note!.id,
        utilisateurId: widget.utilisateurId,
        titre: titre,
        contenu: contenu,
        dateModification: dateModification,
      );

      await _databaseManager.updateNote(noteModifiee);
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modification = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(modification ? 'Modifier la note' : 'Nouvelle note'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: TextField(
                controller: _contenuController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Contenu de la note',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Annuler'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _enregistrerNote,
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
