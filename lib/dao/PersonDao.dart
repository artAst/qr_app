import 'package:firebase_database/firebase_database.dart';

final reference = FirebaseDatabase.instance.reference().child("person");
final conf = FirebaseDatabase.instance.reference().child("config");

class PersonDao {

  static Future save(String fullname) {
    return reference.push().set({"name": fullname});
  }

  static Future getUsersByName(String name, Function p) {
    return reference.orderByChild("name").equalTo(name).once().then((dataSnapshot) {
      print("SNAPSHOT captured");
      if (dataSnapshot.value != null) {
        dataSnapshot.value.forEach((key,data){
          bool isRegistered = false;
          if(data["registered"] != null) {
            isRegistered = data["registered"];
          }
          print("Registered: $isRegistered");
          if(!isRegistered) {
            // save to RTDB registered true
            reference.child(key).set({
              "name": data["name"],
              "registered": true
            });
            // increment count
            incrementCount().then((cnt){
              print("increment count: $cnt");
              Function.apply(p, [{"id":key, "name": data["name"], "registered": isRegistered, "count": cnt}]);
            });
          } else {
            getCount().then((cnt){
              print("Get count: $cnt");
              Function.apply(p, [{"id":key, "name": data["name"], "registered": isRegistered, "count": cnt}]);
            });
          }
        });
      } else {
        print("NO SNAPSHOT");
        Function.apply(p, [null]);
      }
    });
  }

  static Future getCount() {
    return conf.child("count").once().then((DataSnapshot data) {
      if (data?.value != null) {
        return data.value;
      }
      else {
        return 0;
      }
    });
  }

  static Future incrementCount() {
    return conf.child("count").once().then((DataSnapshot data){
      if(data?.value != null) {
        if(data.value is int) {
          // increment count
          int ctr = data.value;
          ctr += 1;
          conf.child("count").set(ctr);
          return ctr;
        } else {
          return data.value;
        }
      } else {
        int ctr = 1;
        conf.child("count").set(ctr);
        return ctr;
      }
    });
  }
}