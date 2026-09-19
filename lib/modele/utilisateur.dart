class Utilisateur {
  final int? id;
  final String nomUtilisateur;
  final String motDePasseHash;

  const Utilisateur({
    required this.id,
    required this.nomUtilisateur,
    required this.motDePasseHash,
  });

  const Utilisateur.sansId({
    required this.nomUtilisateur,
    required this.motDePasseHash,
  }) : id = null;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nomUtilisateur': nomUtilisateur,
      'motDePasseHash': motDePasseHash,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nomUtilisateur: map['nomUtilisateur'],
      motDePasseHash: map['motDePasseHash'],
    );
  }
}
