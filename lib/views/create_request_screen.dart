import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({ Key? key }) : super(key: key);

  @override
  _CreateRequestScreenState createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {

  @override
  void initState() {
    
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