import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'newentry.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Our Note';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    this.title,
    this.note,
    this.author,
    this.submitDate,
  });

  final String title;
  final String note;
  final String author;
  final String submitDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$note',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$submitDate ★',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    this.thumbnail,
    this.title,
    this.note,
    this.author,
    this.submitDate,
  });

  final Widget thumbnail;
  final String title;
  final String note;
  final String author;
  final String submitDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  note: note,
                  author: author,
                  submitDate: submitDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoteEntry {
  String title;
  String note;
  String author;
  DateTime submitDate;

  NoteEntry.fromSnapShot(DataSnapshot snapshot):
        title = snapshot.value['title'],
        note = snapshot.value['note'],
        author = snapshot.value['author'],
        submitDate = new DateTime.fromMillisecondsSinceEpoch(snapshot.value['submitDate']);
}

/// This is the stateless widget that the main application instantiates.
class _MyHomePageState extends State<MyHomePage> {
  List<NoteEntry> entries = new List();  // チャッtのメッセージリスト
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  initState() {
    super.initState();
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event e) {
    setState(() {
      entries.add(new NoteEntry.fromSnapShot(e.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Our Note')),
     body: ListView.builder(
         itemCount: entries.length,
         itemBuilder: (context, index) => _buildRow(index)),
     floatingActionButton: FloatingActionButton(
         // onPressed: _addItem,
         onPressed: () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => NewEntry()),
           );
         },
         child: Icon(Icons.add),
         backgroundColor: Colors.blue,
     ),
   );
  }

  Widget _buildRow(int index) {
    int viewIndex = entries.length - index - 1;
    return CustomListItemTwo(
      thumbnail: Container(
        decoration: const BoxDecoration(color: Colors.pink),
      ),
      title: entries[viewIndex].title,
      note: entries[viewIndex].note,
      author: entries[viewIndex].author,
      submitDate: entries[viewIndex].submitDate.toString(),
    );
  }
}