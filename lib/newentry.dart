import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewEntry extends StatefulWidget {
  final String username;

  const NewEntry({ Key key, this.username }): super(key: key);

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
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _title = "";
    var _note = "";
    final _author = widget.username;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(title: Text('New Entry')),
        body: Builder(
          builder: (context) =>
        SingleChildScrollView(
          child: Form(
      key: _formKey,
      child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Input title',
                labelText: 'Title'
              ),
              style: TextStyle(
                fontFamily: "Hiragino Sans",
                locale: Locale("ja", "JP"),
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
              style: TextStyle(
                fontFamily: "Hiragino Sans",
                locale: Locale("ja", "JP"),
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
            Column(
              children: <Widget>[
                Center(
                  child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
                ),
                SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ],
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
                      'author': _author,
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
      ))),
        ),
    ),
    );
  }
}