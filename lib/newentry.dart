import 'package:flutter/material.dart';

class NewEntry extends StatefulWidget {
 @override
 _NewEntryState createState() {
   return _NewEntryState();
 }
}

/// This is the stateless widget that the main application instantiates.
class _NewEntryState extends State<NewEntry> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('New Entry')),
     body: _buildBody(context),
   );
  }

  Widget _buildBody(BuildContext context) {
    return Text('New Page');
  }
}