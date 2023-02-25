import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_with_model/page/home_page.dart';
import 'package:firestore_crud_with_model/page/sign_up.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback? onClick;
  SignInPage({super.key, this.onClick});

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
                      : const Text('SignIn')),
              const Spacer(),
              Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('if you have no account'),
                    TextButton(
                        onPressed: widget.onClick,
                        // () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => SignUp(),
                        //     ),
                        //   );
                        // },
                        child: const Text('Sign UP')),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )
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
              email: emailC.text,
              password: passwordC.text
              )
          .then((value) {
        setState(() {
          isSinging = false;
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('Some error is :  $e');
    }
  }
}
