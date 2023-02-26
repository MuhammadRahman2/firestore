import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  final VoidCallback? onClick;
  SignUp({this.onClick});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _displayName;
  String? _email;
  String? _password;
  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        //       final auth = await FirebaseAuth.instance;
        //       final result = await auth.createUserWithEmailAndPassword(
        //         email: _emailController.text.trim(),
        //         password: _passwordController.text.trim(),
        //       );
        //       await result.user!.updateDisplayName(_displayNameController.text.trim());

        final  auth =  FirebaseAuth.instance;
        
          UserCredential result =await auth.createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
            );
        User? user = result.user;
        
        if (user != null) {
          //add display name for just created user
          await user.updateDisplayName(_displayNameController.text.trim());
          //get updated user
          await user.reload();
          user = auth.currentUser;
          //print final version to console
          print("Registered user:");
          print(user);
        }
      } catch (error) {
        print('Error is $error');
        setState(() {
          _isLoading = false;
        });
        String errorMessage = 'Authentication failed';
        if (error is FirebaseAuthException) {
          errorMessage = error.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _displayNameController,
                      decoration:
                          const InputDecoration(labelText: 'Display Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a display name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _displayName = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            child: const Text('Sign Up'),
                          ),
                  ],
                ),
              ),
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
}
