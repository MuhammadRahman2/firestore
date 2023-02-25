import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final VoidCallback? onClick;
  SignUp({super.key, this.onClick});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  bool? isSigning = false;

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
          child: Column(children: [
            TextField(
              controller: usernameC,
              decoration: const InputDecoration(hintText: 'username'),
            ),
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
                  signUpUser();
                },
                child: isSigning == true
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Sign UP')),
            Container(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('if you have no account'),
                  TextButton(
                      onPressed: widget.onClick,
                      //() {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (_) => SignUp(),),);
                      // },
                      child: const Text('Sign in')),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future signUpUser() async {
    setState(() {
      isSigning = true;
    });
    try {
       await FirebaseAuth.instance
          .createUserWithEmailAndPassword(       
          email: emailC.text,
           password: passwordC.text
          )
          .then((value) {
        setState(
          () => isSigning = false,
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('SignUp error is: $e');
    }
  }
}
