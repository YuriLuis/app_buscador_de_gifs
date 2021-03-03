import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      print("trending");
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=FPxMUec9uNWZkz2yvfZJq5DbLSfiAjZn&limit=20&rating=g');
    } else {
      print("search");
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=FPxMUec9uNWZkz2yvfZJq5DbLSfiAjZn&q=$_search&limit=20&offset=$_offset&rating=g&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    print("Passou aqui");
    _getGifs().then((map) => print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui!",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                    style: TextStyle(color: Colors.white,fontSize: 18.0),
                    textAlign: TextAlign.center,
                    onSubmitted :(texto){
                      setState(() {
                        _search = texto;
                      });
                    },
                ),
          ),
          Expanded(child: FutureBuilder(
            future: _getGifs(),
            // ignore: missing_return
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                   width: 200.0,
                   height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default :
                  if(snapshot.hasError) return Container();
                  else return _createGifTable(context, snapshot);
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
      return GridView.builder(
        padding: EdgeInsets.all(10.0) ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
          ),
          itemCount: snapshot.data["data"].length,
          // ignore: missing_return
          itemBuilder: (context, index){
            return GestureDetector(
              child: Image.network(snapshot.data["data"] [index] ["images"]["fixed_height"]["url"] ,
              height: 300,
              fit: BoxFit.cover,),
            );
          }
      );
  }
}