import 'package:flutter/material.dart';
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
    this.subtitle,
    this.author,
    this.publishDate,
  });

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

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
                '$subtitle',
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
                '$publishDate ★',
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
    this.subtitle,
    this.author,
    this.publishDate,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;

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
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class _MyHomePageState extends State<MyHomePage> {
  int value = 2;
  var mapping1 = {
    'title': '今日は暑いですね〜',
    'subtitle': 'いやー、暑いっす。ほんと、暑いっす。',
    'author': 'Ayaka',
    'publishDate': 'Jun 29',
  };
  var mapping2 = {
    'title': 'はじめての',
    'subtitle': 'アプリ開発',
    'author': 'Akihiko',
    'publishDate': 'Jun 29',
  };

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Our Note')),
     body: ListView.builder(
         itemCount: value,
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
    var maparr = [mapping1, mapping2];
    var mapping = maparr[index % 2];
    return CustomListItemTwo(
      thumbnail: Container(
        decoration: const BoxDecoration(color: Colors.pink),
      ),
      title: mapping['title'],
      subtitle: mapping['subtitle'],
      author: mapping['author'],
      publishDate: mapping['publishDate'],
    );
  }
}