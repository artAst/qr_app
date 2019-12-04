import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'screens/qr_page.dart';
import 'screens/add_person.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dao/PersonDao.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/' : (context) => new MyHomePage(),
        '/qr' : (context) => new qr_page(),
        '/add_person' : (context) => new add_person(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _reader = "";
  bool existsDb = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR SCANNER"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, "/add_person");
              },
              child: new Text("Add Name in Firebase"),
              color: Colors.blue,
            ),
            new MaterialButton(
              onPressed: scan,
              child: new Text("QR SCAN"),
              color: Colors.blue,
            ),
            new MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, "/qr");
              },
              child: new Text("QR GENERATE"),
              color: Colors.blue,
            ),
            Text("QR DATA: $_reader", softWrap: true, style: TextStyle(fontSize: 20.0)),
            Text("Exists in DB: $existsDb", softWrap: true, style: TextStyle(fontSize: 20.0))
          ],
        ),
      ),
    );
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();
      if(!mounted){return;}
      setState(() {
        _reader = reader;
      });

      if(_reader.isNotEmpty) {
        PersonDao.getUsersByName(_reader, (arrData){
          setState(() {
            if(arrData != null) {
              // person exists
              existsDb = true;
            }
          });
        });
      }
    } on PlatformException catch(e) {
      if(e.code == BarcodeScanner.CameraAccessDenied) {
        _reader = "camera access denied";
      }
      else {
        _reader = "unkown error $e";
      }
    } on FormatException {
      setState(() => _reader = "user return without scanning");
    } catch(e) {
      setState(() => _reader = "unkown error $e");
    }
  }
}
