import 'package:club_app_frontend/fb_helper.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'signin.dart';
import '../utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          heading(),
                          const SizedBox(height: 25),
                          buildField(nameController, "Full Name"),
                          const SizedBox(height: 10),
                          buildField(emailController, "Email"),
                          const SizedBox(height: 10),
                          buildField(passwordController, "Password"),
                          const SizedBox(height: 25),
                          signUpButton(nameController.text,
                              emailController.text, context),
                          const SizedBox(height: 25),
                          continueWithGoogle(),
                          const SizedBox(height: 25),
                          bottomSignInText(),
                        ])))));
  }

  Widget heading() {
    return (Column(children: [
      const CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('assets/logo.png'),
      ),
      const SizedBox(height: 25),
      Text(
        'Sign up for SciClubs!',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 16,
        ),
      ),
    ]));
  }

  Widget signUpButton(String email, String password, BuildContext context) {
    return TextButton(
      onPressed: () {
        createAccount(emailController.text, passwordController.text);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => Home(),
        //   ),
        // );
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
            "Sign Up",
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

  Widget buildField(TextEditingController t, String info) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
      height: 25,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: TextFormField(
        controller: t,
        decoration: InputDecoration.collapsed(
          hintText: '$info',
          hintStyle: const TextStyle(fontSize: 16.0),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your ${info.toLowerCase()}';
          }
          return null;
        },
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

  Widget bottomSignInText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already a member?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
            child: Text(
              'Sign in now.',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }
}
