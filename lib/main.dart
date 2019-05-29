import 'package:flutter/material.dart';
import 'model.dart';
//import 'package:sqflite/sqflite.dart';
//import 'dart:async';
//import 'package:path/path.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => FirstScreen(),
        '/list': (context) => SecondScreen(),
      },
    ));

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key key}) : super(key: key);

  _FirstScreenState createState() => new _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MongoDB Flutter",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("MongoDB Flutter"),
        ),
        body: new Column(
          children: <Widget>[
            new TextField(
              controller: firstController,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(labelText: "First Name"),
            ),
            new TextField(
              controller: lastController,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(labelText: "Last Name"),
            ),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {
              String first = firstController.text;
              String last = lastController.text;
              Name name = Name(firstName: first, lastName: last);
              insertName(name);
              firstController.text = "";
              lastController.text = "";
              Navigator.pushNamed(context, "/list");
            }),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String pageName;

  const SecondScreen({Key key, this.pageName}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List _names = new List();
  List<Widget> _namesTiles = new List();

  @override
  void initState() {
    super.initState();
    _getNames();
  }

  _getNames() async {

  _names = await names();

    setState(() {
      for (var x in _names) {
        Text text = new Text("$x");
        _namesTiles.add(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Name List"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => _namesTiles[index],
          itemCount: _namesTiles.length,
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.fast_rewind),
            onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}
