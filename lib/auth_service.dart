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
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("googleAuth: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}");
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

      UserCredential result = await _auth.signInWithCredential(credential);
      print("LOOK HERE DUMMY ${result.user}");
      return result.user;

    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    print("Signing out...");
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("User signed out.");
  }
}
