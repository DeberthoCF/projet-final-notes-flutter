import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modele/note.dart';
import '../modele/utilisateur.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialiserDatabase();
    return _database!;
  }

  Future<Database> _initialiserDatabase() async {
    final chemin = join(await getDatabasesPath(), 'noteflow.db');

    return openDatabase(
      chemin,
      version: 1,

      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE utilisateurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nomUtilisateur TEXT UNIQUE NOT NULL,
            motDePasseHash TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            utilisateurId INTEGER NOT NULL,
            titre TEXT NOT NULL,
            contenu TEXT NOT NULL,
            dateModification TEXT NOT NULL,
            FOREIGN KEY(utilisateurId)
              REFERENCES utilisateurs(id)
              ON DELETE CASCADE
          )
          ''');
      },
    );
  }

  Future<bool> nomUtilisateurExiste(String nomUtilisateur) async {
    final db = await database;

    final resultat = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ?',
      whereArgs: [nomUtilisateur],
    );

    return resultat.isNotEmpty;
  }

  Future<int> creerUtilisateur(Utilisateur utilisateur) async {
    final db = await database;

    return db.insert('utilisateurs', utilisateur.toMap());
  }

  Future<Utilisateur?> connecterUtilisateur(
    String nomUtilisateur,
    String motDePasseHash,
  ) async {
    final db = await database;

    final resultat = await db.query(
      'utilisateurs',
      where: 'nomUtilisateur = ? AND motDePasseHash = ?',
      whereArgs: [nomUtilisateur, motDePasseHash],
      limit: 1,
    );

    if (resultat.isEmpty) {
      return null;
    }

    return Utilisateur.fromMap(resultat.first);
  }

  Future<List<Note>> getAllNotes(int utilisateurId) async {
    final db = await database;

    final maps = await db.query(
      'notes',
      where: 'utilisateurId = ?',
      whereArgs: [utilisateurId],
      orderBy: 'id DESC',
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> insertNote(Note note) async {
    final db = await database;

    return db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;

    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ? AND utilisateurId = ?',
      whereArgs: [note.id, note.utilisateurId],
    );
  }

  Future<int> deleteNote(int id, int utilisateurId) async {
    final db = await database;

    return db.delete(
      'notes',
      where: 'id = ? AND utilisateurId = ?',
      whereArgs: [id, utilisateurId],
    );
  }
}
