import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fetchData', () {
    testWidgets('returns a list of items', (tester) async {
      final mockClient = MockClient();
      final myApp = MyApp(client: mockClient);

      await tester.pumpWidget(MaterialApp(home: myApp));
      await tester.pumpAndSettle(); // adiciona uma pequena pausa

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });
  });
}

class MyApp extends StatefulWidget {
  final http.Client client;

  MyApp({required this.client});

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
    final response = await widget.client
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
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
    return Scaffold(
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
    );
  }
}

class MockClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response =
        http.Response('[{"title": "Test Title", "body": "Test Body"}]', 200);
    return http.StreamedResponse(
        Stream.value(utf8.encode(response.body)), response.statusCode);
  }
}
