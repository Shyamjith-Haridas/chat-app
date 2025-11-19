class UsersModel {
  final String uid;
  final String name;
  final String email;

  UsersModel({required this.uid, required this.name, required this.email});

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      uid: map['uid'] as String,
      name: map['name'] as String? ?? 'unknown name',
      email: map['email'] as String? ?? 'unknown email',
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
