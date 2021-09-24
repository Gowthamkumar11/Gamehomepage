import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mscplay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePageGame(),
    );
  }
}

Future fetchUsers() async {
  final Uri apiUrl =
      Uri.parse("https://stgapiugv2.seamless-hptech.com/getCommonViewData");

  dynamic result = await http.get(apiUrl, headers: {
    "lang-code": "en",
    "is-mobile": "true",
    "l-state": "yes",
    "d-key": "EABAAAA",
    "x-api-key": "YaWRAG3lRD",
    "Accept": "application/json"
  });

  Map<String, dynamic> map = json.decode(result.body);
  dynamic data1 = map["games_data"];
  return data1;
}

class HomePageGame extends StatefulWidget {
  const HomePageGame({Key? key}) : super(key: key);

  @override
  _HomePageGameState createState() => _HomePageGameState();
}

class _HomePageGameState extends State<HomePageGame> {
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    String url = 'https://files.sitestatic.net/GameImage/';
    String imgurl =
        'https://files.sitestatic.net/ImageFile/60fff38cdedb3_mscplay.png';
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image(
          image: NetworkImage(imgurl),
          width: 130,
        ),
        actions: [
          Row(
            children: const [
              Icon(Icons.person_outlined),
              SizedBox(
                width: 5,
              ),
              Text('LOGIN'),
            ],
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          dynamic k = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: k.keys.length,
            itemBuilder: (context, index1) {
              final heading = k.keys.elementAt(index1);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      heading.replaceFirst(
                          heading[0], (heading[0]).toUpperCase()),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: Scrollbar(
                      controller: _scrollController,
                      thickness: 2,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: k[heading].length,
                        itemBuilder: (context, index) {
                          final heading2 = k[heading].values.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            url +
                                                (heading2['img_src'])
                                                    .replaceAll('{{device}}',
                                                        "thumbnail")
                                                    .replaceAll(
                                                        '{{type}}', "normal"),
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                    width: 120,
                                    height: 120,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(),
                                    width: 120,
                                    child: Center(
                                      child: FittedBox(
                                        child: Text(
                                          heading2['game_name'].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
