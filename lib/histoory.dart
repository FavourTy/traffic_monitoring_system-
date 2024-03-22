//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'stylles/database.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:FutureBuilder<List<Feed>>(
  future: DatabaseHelper.instance.fetchFeeds(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final feed = snapshot.data![index];
          return ListTile(
            title: Text(feed.field1),
            subtitle: Text(feed.createdAt.toString()),
          );
        },
      );
    } else if (snapshot.hasError) {
      return const Text('An error occurred!');
    } else {
      return const CircularProgressIndicator();
    }
  },
)

    );
  }
}