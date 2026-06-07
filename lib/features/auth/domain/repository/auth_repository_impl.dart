import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_life_rsvp_exam/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final String userId = user.user?.uid ?? '';
    await _firestore.collection('users').doc(userId).set({
      'id': userId,
      'name': name,
      'email': email,
    }, SetOptions(merge: true));
  }
}
