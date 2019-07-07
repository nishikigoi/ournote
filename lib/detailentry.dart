import 'package:flutter/material.dart';

class DetailEntry extends StatelessWidget {
  final String title, note, author, submitDate;
  DetailEntry({
    @required this.title,
    @required this.note,
    @required this.author,
    @required this.submitDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(bottom: 16.0)),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 18.0)),
        Text(
          author + ',   ' + submitDate,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 18.0)),
        Text(
          note,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ]
    ));
  }
}
