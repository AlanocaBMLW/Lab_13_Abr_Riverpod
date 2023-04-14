import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}
//recibe la imagen en formato JSON
Future<String> getDogImage() async {
  final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
  final json = jsonDecode(response.body);//decodfija el json y lo guarda en una variable
  final String imageUrl = json['message'];//devuelve la imagen concreta
  return imageUrl;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String>? _dogImageFuture;
  late ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _dogImageFuture = getDogImage();
  }

  void _updateImage() {
    setState(() {
      _dogImageFuture = getDogImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Image App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dog Image'),
        ),
        body: Center(
          child: FutureBuilder<String>(
            future: _dogImageFuture,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {//esto muestra el circulo de progreso mientras aguarda la nueva imagen
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                _imageProvider = NetworkImage(snapshot.data!);//agarra la imagen del archivo tipo json
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: _imageProvider != null
                              ? Image(
                                  image: _imageProvider!,
                                  fit: BoxFit.cover,
                                )
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _updateImage,
                      child: Text('Update Image'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

