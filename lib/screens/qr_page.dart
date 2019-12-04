import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr_page extends StatefulWidget {
  @override
  _qr_pageState createState() => new _qr_pageState();
}

class _qr_pageState extends State<qr_page> {
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  Widget qr = null;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    _children.addAll([
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
            AlertDialog(title: new Text("Added"), content: new Text("New Person added."));
            setState(() {
              qr = new QrImage(
                data: "${fname.text} ${lname.text}",
                version: QrVersions.auto,
                size: 200.0,
              );
            });
            fname.clear();
            lname.clear();
          }
          else {
            AlertDialog(title: new Text("Error"), content: new Text("Firstname/Lastname empty."));
          }
        },
        child: new Text("GENERATE"),
        color: Colors.blue,
      ),
    ]);

    if(qr != null) {
      _children.addAll([
        new Padding(padding: const EdgeInsets.only(top: 20.0)),
        qr
      ]);
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text("QR GENERATE - Name"),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          /*children: <Widget>[
            new QrImage(
              data: "1234567890",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],*/
          children: _children,
        ),
      ),
    );
  }
}