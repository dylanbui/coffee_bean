import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialLoginType { google, apple }

class SocialAuthResult {
  final String idToken;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? givenName;
  final String? familyName;

  SocialAuthResult({
    required this.idToken,
    this.email,
    this.displayName,
    this.photoUrl,
    this.givenName,
    this.familyName,
  });
}

class SocialAuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  static Future<void> disconnectSocialAccount(SocialLoginType type) async {
    try {
      if (type == SocialLoginType.google) {
        // Clear Google Sign-In session
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }

      // Note: sign_in_with_apple does not provide a programmatic signOut method
      // as it's managed by the iOS system. The user remains "signed in" to the app
      // from the system's perspective until they revoke access in iOS Settings.
    } catch (e) {
      // Ignore errors during sign out
    }
  }

  static Future<SocialAuthResult?> login(SocialLoginType type) async {
    try {
      if (type == SocialLoginType.google) {
        final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

        final googleAuth = googleUser.authentication;
        if (googleAuth.idToken == null) return null;

        return SocialAuthResult(
          idToken: googleAuth.idToken!,
          email: googleUser.email,
          displayName: googleUser.displayName,
          photoUrl: googleUser.photoUrl,
        );
      } else if (type == SocialLoginType.apple) {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        );

        if (credential.identityToken == null) return null;

        return SocialAuthResult(
          idToken: credential.identityToken!,
          email: credential.email,
          givenName: credential.givenName,
          familyName: credential.familyName,
          displayName: "${credential.givenName ?? ""} ${credential.familyName ?? ""}".trim(),
        );
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
