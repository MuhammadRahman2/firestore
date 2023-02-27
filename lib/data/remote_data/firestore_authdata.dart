
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import '../model/userauth_datamodel.dart';

class FirestoreAuthData {
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // static Stream<List<UserModel>> getUser()  {
  //   final userCollection = FirebaseFirestore.instance.collection('users');
  //   return userCollection.snapshots().map((doc) => UserModel.fromSnapshot(doc)).toList();
  // }
  // or  right view 👇 
  static Stream<List<UserAuthDataModel>> read()  {
    final userCollection =  FirebaseFirestore.instance.collection("usersAuth");
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserAuthDataModel.fromSnapshot(e)).toList());

  }

  static Future create(UserAuthDataModel userAuth) async {
    final userCollection = FirebaseFirestore.instance.collection("usersAuth");
    final uid = userCollection.doc().id;
    final docRef = userCollection.doc(uid);
    final newUserAuth = UserAuthDataModel(
      id: uid,
        username: userAuth.username, 
        email: userAuth.email
    ).toJson();
    try {
      await docRef.set(newUserAuth);
    } catch (e) {
      print("some error occured firestoreCreate: $e");
    }
  }

  static Future update(UserAuthDataModel userAuth) async {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(userAuth.id);

    final newUserAuth = UserAuthDataModel(
        id: userAuth.id,
        username: userAuth.username,
        email: userAuth.email
    ).toJson();

    try {
      await docRef.update(newUserAuth);
    } catch (e) {
      print("some error occured firestoreUpdata:  $e");
    }
  }

  // static Future delete(UserModel user) async {
  //   final userCollection = FirebaseFirestore.instance.collection("users");

  //   final docRef = userCollection.doc(user.id).delete();

  // }



}