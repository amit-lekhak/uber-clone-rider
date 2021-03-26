import 'package:firebase_database/firebase_database.dart';

class Users {
  String id;
  String email;
  String name;
  String phone;

  Users({this.email, this.id, this.name, this.phone});

  Users.fromSnapShot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
  }
}
