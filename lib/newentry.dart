import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class NewEntry extends StatefulWidget {
 @override
 _NewEntryState createState() {
   return _NewEntryState();
 }
}

/// This is the stateless widget that the main application instantiates.
class _NewEntryState extends State<NewEntry> {
  final databaseReference = FirebaseDatabase.instance.reference();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _title = "";
    var _note = "";
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text('New Entry')),
        body: Builder(
          builder: (context) =>
        Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input title',
              labelText: 'Title'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter some text';
              }
              return null;
            },
            onSaved: (String value) => _title = value,
          ),
          SizedBox(height: 24.0),
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tell us about your story',
                labelText: 'Note'
            ),
            maxLines: 3,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter some text';
              }
              return null;
            },
            onSaved: (String value) => _note = value,
          ),
          SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  var uuid = new Uuid();
                  databaseReference.child(uuid.v4()).set({
                    'title': _title,
                    'note': _note,
                    'author': 'Akihiko',
                    'submitDate': new DateTime.now().millisecondsSinceEpoch,
                  });
                  Navigator.pop(context);
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Posted note.')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      )),
    ),
    );
  }
}