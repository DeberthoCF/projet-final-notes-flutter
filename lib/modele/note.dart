class Note {
  final int? id;
  final int utilisateurId;
  final String titre;
  final String contenu;
  final String dateModification;

  const Note({
    required this.id,
    required this.utilisateurId,
    required this.titre,
    required this.contenu,
    required this.dateModification,
  });

  const Note.sansId({
    required this.utilisateurId,
    required this.titre,
    required this.contenu,
    required this.dateModification,
  }) : id = null;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'utilisateurId': utilisateurId,
      'titre': titre,
      'contenu': contenu,
      'dateModification': dateModification,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      utilisateurId: map['utilisateurId'],
      titre: map['titre'],
      contenu: map['contenu'],
      dateModification: map['dateModification'],
    );
  }
}
