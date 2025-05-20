import 'package:flutter/material.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({ Key? key }) : super(key: key);

  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}