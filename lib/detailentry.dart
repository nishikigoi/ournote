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
    return Column(
      children: <Widget>[
        Text(title),
        Text(note),
        Text(author),
        Text(submitDate),
      ]
    );
  }
}
