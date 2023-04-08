import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter HTTP Example'),
        ),
        body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            final item = _data[index];
            return ListTile(
              title: Text(item['title']),
              subtitle: Text(item['body']),
            );
          },
        ),
      ),
    );
  }
}
