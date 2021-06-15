import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
    );
  }

  factory User.fromFireStore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map map = doc.data() ?? {'name': '', 'age': 0};

    return User(
      name: map['name'],
      age: map['age'],
    );
  }
}
