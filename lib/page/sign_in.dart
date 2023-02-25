import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_with_model/page/home_page.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  bool? isSinging = false;

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              TextField(
                controller: emailC,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: passwordC,
                decoration: const InputDecoration(hintText: 'password'),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(
                        double.infinity,
                        45,
                      )),
                  onPressed: () {
                    signInUser();
                  },
                  child: isSinging == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('SignIn'))
            ],
          ),
        ),
      ),
    );
  }

  Future signInUser() async {
    setState(() {
      isSinging = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailC.text, password: passwordC.text)
          .then((value) {
        setState(() {
          isSinging = false;
        });
      });
    } catch (e) {
      print('Some error is :  $e');
    }
  }
}
