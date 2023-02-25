
import 'package:flutter/material.dart';
import '../data/model/user_model.dart';
import '../data/remote_data/firestore_helper.dart';

class EditPage extends StatefulWidget {
  final UserModel user;
  const EditPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController? _usernameController;
  TextEditingController? _ageController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.username);
    _ageController = TextEditingController(text: widget.user.age);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController!.dispose();
    _ageController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "age"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: (){
                 FirestoreHelper.update(UserModel(id: widget.user.id, username: _usernameController!.text, age: _ageController!.text),).then((value) {
                    Navigator.pop(context);
                  });
              }, child: const Text('Updata Value'))
            ],
          ),
        ),
      ),
    );
  }
}