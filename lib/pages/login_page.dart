import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stockappflutter/components/my_button.dart';
import 'package:stockappflutter/pages/signup_page.dart';
import 'package:stockappflutter/utilities/auth_utils.dart';
import '../components/custom_text_field.dart';
import 'package:stockappflutter/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';
  List<Color> colors = [Colors.blue, Colors.purple];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) => changeColors());
  }

  @override
  void dispose() {
    timer.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void changeColors() {
    setState(() {
      colors = colors.reversed.toList();
    });
  }


  void signUserIn() async {
    OverlayEntry loadingIndicator = OverlayEntry(
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    navigatorKey.currentState?.overlay?.insert(loadingIndicator);

    print('Sign in button pressed');
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
    print('Sign in started');

    final message = await logUserIn(emailController.text, passwordController.text);

    loadingIndicator.remove();
    if(message == null){
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/home',
        (route) => false,
      );
    }else{
      print('Sign in failed: $message');
      setState((){
        errorMessage = message;
      });
    }

    print('Sign in process completed');
  }

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your email to reset password';
      });
      return;
    }

    final message = await resetUserPassword(emailController.text);

    if(message == null){
      errorMessage = 'Password reset email sent';
    }else{
      errorMessage = message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 150),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.show_chart,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false,
                    onChanged: (value) {
                      print('Email input: $value');
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    onChanged: (value) {
                      print('Password input: $value');
                    },
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    text: "Sign In",
                    onTap: signUserIn,
                  ),
                  if (errorMessage.isNotEmpty) const SizedBox(height: 25),
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      // Navigate to sign-up page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
