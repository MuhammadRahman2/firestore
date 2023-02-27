import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthDataModel {
  // final String _id;
  final String? id;
  final String? email;
  final String? username;
  // final String? password;

  UserAuthDataModel({this.username,this.email, this.id});

  factory UserAuthDataModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserAuthDataModel(
      username: snapshot['username'],
      email: snapshot['email'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "id": id,
      };
}
