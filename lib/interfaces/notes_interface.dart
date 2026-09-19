import 'package:flutter/material.dart';

import '../modele/note.dart';
import '../modele/utilisateur.dart';
import '../services/database_manager.dart';
import 'note_editeur_interface.dart';
import 'accueil_interface.dart';

class NotesInterface extends StatefulWidget {
  final Utilisateur utilisateur;

  const NotesInterface({super.key, required this.utilisateur});

  @override
  State<NotesInterface> createState() => _NotesInterfaceState();
}

class _NotesInterfaceState extends State<NotesInterface> {
  final DatabaseManager _databaseManager = DatabaseManager();

  List<Note> _notes = [];

  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  Future<void> _chargerNotes() async {
    final notes = await _databaseManager.getAllNotes(widget.utilisateur.id!);

    if (!mounted) return;

    setState(() {
      _notes = notes;
      _chargement = false;
    });
  }

  Future<void> _ouvrirEditeur({Note? note}) async {
    final resultat = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditeurInterface(
          utilisateurId: widget.utilisateur.id!,
          note: note,
        ),
      ),
    );

    if (resultat == true) {
      await _chargerNotes();
    }
  }

  Future<void> _supprimerNote(Note note) async {
    final confirmation = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note'),

          content: Text(
            'Voulez-vous vraiment supprimer '
            '"${note.titre}" ?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmation != true) {
      return;
    }

    await _databaseManager.deleteNote(note.id!, widget.utilisateur.id!);

    await _chargerNotes();
  }

  String _formaterDate(String valeur) {
    final date = DateTime.tryParse(valeur);

    if (date == null) {
      return valeur;
    }

    final jour = date.day.toString().padLeft(2, '0');
    final mois = date.month.toString().padLeft(2, '0');

    return '$jour/$mois/${date.year}';
  }

  Future<void> _demanderDeconnexion() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirmation == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AccueilInterface()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _demanderDeconnexion,
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bienvenue ${widget.utilisateur.nomUtilisateur} 👋🏾',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: _chargement
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_add_outlined, size: 70),
                        SizedBox(height: 15),
                        Text(
                          'Aucune note pour le moment.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Appuyez sur + pour créer votre première note.'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notes.length,

                    itemBuilder: (context, index) {
                      final note = _notes[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),

                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),

                          title: Text(
                            note.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const SizedBox(height: 8),

                              Text(
                                note.contenu,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Modifiée le '
                                '${_formaterDate(note.dateModification)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () {
                                  _ouvrirEditeur(note: note);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  _supprimerNote(note);
                                },
                              ),
                            ],
                          ),

                          onTap: () {
                            _ouvrirEditeur(note: note);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ouvrirEditeur();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
