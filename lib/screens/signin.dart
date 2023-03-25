import 'package:club_app_frontend/screens/signup.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import '../utils.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              heading(),
              const SizedBox(height: 25),
              textField(
                usernameController,
                'Username',
                false,
              ),
              const SizedBox(height: 10),
              textField(
                passwordController,
                'Password',
                true,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              signInButton(
                  usernameController.text, passwordController.text, context),
              const SizedBox(height: 25),
              continueWithGoogle(),
              const SizedBox(height: 25),
              bottomSignUpText(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget heading() {
    return Column(children: [
      const CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('assets/logo.png'),
      ),
      const SizedBox(height: 25),
      Text(
        'Welcome back to SciClubs!',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
        ),
      )
    ]);
  }

  Widget textField(
    TextEditingController controller,
    String hintText,
    bool obscureText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }

  Widget squareTile(String imagePath) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }

  Widget signInButton(String email, String password, BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget continueWithGoogle() {
    return (Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            squareTile('assets/google.png'),
          ],
        ),
      ],
    ));
  }

  Widget bottomSignUpText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not a member?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: Text('Register now.',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }
}
