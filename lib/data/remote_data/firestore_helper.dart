
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class FirestoreHelper {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // static Stream<List<UserModel>> getUser()  {
  //   final userCollection = FirebaseFirestore.instance.collection('users');
  //   return userCollection.snapshots().map((doc) => UserModel.fromSnapshot(doc)).toList();
  // }
  // or  right view 👇 
  static Stream<List<UserModel>> read()  {
    final userCollection =  FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());

  }

  static Future create(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final uid = userCollection.doc().id;
    final docRef = userCollection.doc(uid);
    final newUser = UserModel(
      id: uid,
        username: user.username,
        age: user.age
    ).toJson();
    try {
      await docRef.set(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future update(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.id);

    final newUser = UserModel(
        id: user.id,
        username: user.username,
        age: user.age
    ).toJson();

    try {
      await docRef.update(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future delete(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.id).delete();

  }



}