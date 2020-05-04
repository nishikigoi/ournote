import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'detailentry.dart';
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
                  fontFamily: "Hiragino Sans",
                  locale: Locale("ja", "JP"),
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
                  fontFamily: "Hiragino Sans",
                  locale: Locale("ja", "JP"),
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username;

  @override
  initState() {
    super.initState();
    databaseReference.onChildAdded.listen(_onEntryAdded);
    _handleSignIn()
        .then((FirebaseUser user) => _username =
            user.displayName.startsWith("Akihiko") ? "Akihiko" : "Ayaka")
        .catchError((e) => print(e));
  }

  _onEntryAdded(Event e) {
    setState(() {
      entries.add(new NoteEntry.fromSnapShot(e.snapshot));
      entries.sort((a, b) => b.submitDate.compareTo(a.submitDate));
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
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
             MaterialPageRoute(builder: (context) => NewEntry(username: _username)),
           );
         },
         child: Icon(Icons.add),
         backgroundColor: Colors.blue,
     ),
   );
  }

  Widget _buildRow(int index) {
    const colormap = {
      'Akihiko': Colors.blue,
      'Ayaka': Colors.pink,
    };
    var title = entries[index].title;
    var note = entries[index].note;
    var author = entries[index].author;
    var submitDate = entries[index].submitDate.toString();
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailEntry(
              title: title,
              note: note,
              author: author,
              submitDate: submitDate,
            )),
          );
        },
        child: CustomListItemTwo(
      thumbnail: Container(
        decoration: BoxDecoration(color: colormap[entries[index].author]),
      ),
      title: title,
      note: note,
      author: author,
      submitDate: submitDate,
    ),
    );
  }
}