class Creds {
  final String id;
  final String hashPassword;

  Creds({required this.id, required this.hashPassword});

  factory Creds.fromMap(Map<String, dynamic> map) {
    return Creds(id: map['id'] ?? '', hashPassword: map['hashPassword'] ?? '');
  }
}
