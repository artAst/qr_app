import 'package:firebase_database/firebase_database.dart';

final reference = FirebaseDatabase.instance.reference().child("person");

class PersonDao {

  static Future save(String fullname) {
    return reference.push().set({"name": fullname});
  }

  static Future getUsersByName(String name, Function p) {
    return reference.orderByChild("name").equalTo(name).once().then((dataSnapshot) {
      if (dataSnapshot.value != null) {
        dataSnapshot.value.forEach((key,data){
          Function.apply(p, [{"id":key, "name": data["name"]}]);
        });
      }
    });
  }
}