import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }
}

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/'),
    headers: <String, String>{'content-Type': 'application/Json;charset=UTF-8'},
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('failed to create album');
  }
}

void main(List<String> args) {
  runApp(const Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sending data',
      home: Scaffold(
          backgroundColor: Colors.greenAccent,
          appBar: AppBar(
            title: const Text('Add album'),
            centerTitle: true,
            backgroundColor: Colors.teal,
          ),
          body: Center(
            child:
                (_futureAlbum == null) ? bulidColumn() : buildfutureBuilder(),
          )),
    );
  }

  Column bulidColumn() {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          height: 80,
          width: 800,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Albun Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          style: const ButtonStyle(
              // minimumSize: MaterialStateProperty.all(Size(10, 10)),
              minimumSize: MaterialStatePropertyAll(Size(200, 60)),
              backgroundColor: MaterialStatePropertyAll(Colors.tealAccent)),
          child: const Text('Add album'),
        )
      ],
    );
  }

  FutureBuilder<Album> buildfutureBuilder() {
    const Padding(padding: EdgeInsets.all(10));
    return FutureBuilder(
        future: _futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
