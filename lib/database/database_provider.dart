import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider_exam/model/user.dart';

class DatabaseProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User> getUser(String id) async {
    var snap = await _db.collection('user').doc(id).get();
    return User.fromMap(snap.data() ?? {'name': '', 'age': 0});
  }

  Stream<List<User>> getUsers() {
    return _db.collection('user').snapshots().map(
        (list) => list.docs.map((doc) => User.fromFireStore(doc)).toList());
  }
}
