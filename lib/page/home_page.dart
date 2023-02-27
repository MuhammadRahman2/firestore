import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_with_model/data/model/userauth_datamodel.dart';
import 'package:firestore_crud_with_model/page/edit_page.dart';
import 'package:flutter/material.dart';

import '../data/model/user_model.dart';
import '../data/remote_data/firestore_authdata.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 30, 30, 100),
                  // position: const RelativeRect.fromLTRB(1000.0, 1000.0, 0.0, 0.0),
                  items: [
                    PopupMenuItem(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                    const PopupMenuItem(
                      child: Text('Sitting'),
                    ),
                    // const PopupMenuItem(
                    //   child: Text('Menu Item 3'),
                    // ),
                  ],
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
              // height: 200,
              // child: Column(
              //   children: [
              //     const DrawerHeader(child: Text('Drawer header')),
              child: StreamBuilder<List<UserAuthDataModel>>(
                  stream: FirestoreAuthData.read(),
                  builder: (context, snapshot) {
                    final userData = snapshot.data;
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: userData!.length,
                          itemBuilder: (context, index) {
                            final singleUser = userData[index];
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const DrawerHeader(
                                      child: Text('Drawer header')),
                                  Text('Email: ${singleUser.email.toString()}'),
                                  const SizedBox(height: 3),
                                  Text(
                                      'Username:  ${singleUser.username.toString()}'),
                                ],
                              ),
                            );
                          });
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('Some error occured');
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })
              //   ],
              // ),
              ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
              Text('uname: ${FirebaseAuth.instance.currentUser!.displayName}'),
              const SizedBox(
                height: 20,
              ),
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
