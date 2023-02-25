import 'package:firestore_crud_with_model/page/sign_in.dart';
import 'package:firestore_crud_with_model/page/sign_up.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isSignIn = true;
  @override
  Widget build(BuildContext context) {
    return isSignIn ? SignInPage(onClick: switchPage,): SignUp(onClick:  switchPage,);
  }
  switchPage()=>setState(() => isSignIn =! isSignIn );
}
