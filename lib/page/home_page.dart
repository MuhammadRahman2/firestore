import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_crud_with_model/page/edit_page.dart';
import 'package:flutter/material.dart';

import '../data/model/user_model.dart';
import '../data/remote_data/firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Firebase Create"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "username"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "age"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    FirestoreHelper.create(UserModel(
                            username: usernameController.text,
                            age: ageController.text))
                        .then((value) {
                      usernameController.clear();
                      ageController.clear();
                    });
                  },
                  child: const Text('Add data')),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<List<UserModel>>(
                  stream: FirestoreHelper.read(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("some error occured"),
                      );
                    }
                    if (snapshot.hasData) {
                      final userData = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: userData.length,
                            itemBuilder: (context, index) {
                              final singleUser = userData[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(singleUser.username.toString()),
                                  subtitle: Text(singleUser.age.toString()),
                                  onLongPress: () {
                                    deleteDialogo(context, singleUser);
                                  },
                                  // leading: Container(
                                  //   width: 40,
                                  //   height: 40,
                                  //   decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                                  // ),
                                  // // title: Text("${singleUser.username}"),
                                  // subtitle: Text("${singleUser.age}"),
                                  trailing: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditPage(
                                                    user: UserModel(
                                                        username:
                                                            singleUser.username,
                                                        age: singleUser.age,
                                                        id: singleUser.id),
                                                  )));
                                    },
                                    child: const Icon(Icons.edit),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> deleteDialogo(BuildContext context, UserModel singleUser) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text("are you sure you want to delete"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    FirestoreHelper.delete(singleUser).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Delete"))
            ],
          );
        });
  }

}
