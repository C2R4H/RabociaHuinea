//Firestore Cloud Package
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  //Uploading User Data to the Firestore cloud database
  Future<void> uploadUser(userdata) async {
    Firestore.instance.collection("users").add(userdata).catchError((e) {
      print(e.toString());
    });
  }

  //Get user info by email
  getUserByEmail(String email) async {
    return Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserByName(String username) async {
    return Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .limit(1)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
      });
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

}
