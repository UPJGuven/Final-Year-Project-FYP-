import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    print("Starting Google sign-in...");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("googleUser: $googleUser");
      if (googleUser == null) {
        print("User cancelled sign-in (googleUser is null).");
        return null; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      print(result.user);

      final user = FirebaseAuth.instance.currentUser;
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(user!.uid);

      final existingDoc = await userRef.get();
      final alreadyExists = existingDoc.exists;

      if (!alreadyExists) {
        print("Creating new user in Firestore...");
      }

      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName,
        if (!alreadyExists) 'hasSeenHelp': false, // Only set if new user
        'photoURL': user.photoURL,
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true));

      return result.user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    print("User signed out");
  }
}
