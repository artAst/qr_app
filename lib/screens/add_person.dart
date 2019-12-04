import 'package:flutter/material.dart';
import 'package:qr_scan/dao/PersonDao.dart';

class add_person extends StatefulWidget {
  @override
  _add_personState createState() => new _add_personState();
}

class _add_personState extends State<add_person> {
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("ADD NAME IN FIREBASE"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "First Name"
              ),
              controller: fname,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Last Name"
              ),
              controller: lname,
            ),
            new MaterialButton(
              onPressed: (){
                if(fname.text.isNotEmpty && lname.text.isNotEmpty) {
                  PersonDao.save("${fname.text} ${lname.text}");
                  AlertDialog(title: new Text("Added"), content: new Text("New Person added."));
                  fname.clear();
                  lname.clear();
                }
                else {
                  AlertDialog(title: new Text("Error"), content: new Text("Firstname/Lastname empty."));
                }
              },
              child: new Text("Add"),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}