import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockappflutter/main.dart';

Future<String?> logUserIn(String email, String password) async {
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    );
    return null;
  } on FirebaseAuthException catch (e){
    return e.message;
  }catch(e){
    return "An unknown error occurred";
  }
}

Future<String?> resetUserPassword(String email) async{
  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return null;
  }on FirebaseAuthException catch(e){
    return e.message;
  }catch(e){
    return "An unknown error occurred";
  }
}

void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
}

String? getUserID() {
  User? user = FirebaseAuth.instance.currentUser;
  if(user == null){
    throw Exception("No user currently signed in");
  }
  return user.uid;
}