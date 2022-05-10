import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NASA ASTRONOMY PICTURE OF THE DAY",
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xff37425B)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  bool isFavourite = false;

  String title = '';
  String explanation = '';
  String dateString = '';
  String hdUrl = '';
  String date = '';
  String copyright = '';
  String dateLink = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void changeDay(String dateLink) async {
    var data = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=' +
            dateLink));
    var decodedData = json.decode(data.body);
    setState(() {
      title = decodedData['title'];
      explanation = decodedData['explanation'];
      dateString = decodedData['date'];
      hdUrl = decodedData['hdurl'];
      date = decodedData['date'];
      copyright = decodedData['copyright'];
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isLoading) {
      print("Here");
      print(dateLink);
      var data = await http.get(Uri.parse(
          'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=' +
              dateLink));
      var decodedData = json.decode(data.body);
      setState(() {
        title = decodedData['title'];
        explanation = decodedData['explanation'];
        dateString = decodedData['date'];
        hdUrl = decodedData['hdurl'];
        date = decodedData['date'];
        copyright = decodedData['copyright'];
        _isLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff333366),
        // ignore: prefer_const_constructors
        title: Center(
          // ignore: prefer_const_constructors
          child: Text(
            "Nasa Picture of The Day",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
        ],
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 5,
                          ),
                        ),
                        child: Image.network(
                          hdUrl,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  //ignore: prefer_const_constructors
                                  : Center(
                                      child: const CircularProgressIndicator(),
                                    ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              title,
                              style: GoogleFonts.pacifico(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AutoSizeText(date,
                                style: GoogleFonts.pacifico(fontSize: 16),
                                textAlign: TextAlign.center),
                            AutoSizeText(
                              "Author: " + copyright,
                              style: GoogleFonts.pacifico(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite),
                              iconSize: 40.0,
                              color: isFavourite
                                  ? Colors.red[400]
                                  : Colors.grey[400],
                              tooltip: 'Add to favorites!',
                              onPressed: () {
                                setState(() {
                                  isFavourite = !isFavourite;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 5.0),
                  child: Center(
                      child: AutoSizeText(explanation,
                          style: const TextStyle(fontSize: 20))),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Photo of the previous day',
                      onPressed: () {
                        DateTime dt = DateTime.parse(dateLink);
                        setState(() {
                          dateLink = DateFormat('yyyy-MM-dd')
                                  .format(dt.subtract(const Duration(days: 1)))
                              as String;
                        });
                        changeDay(dateLink);
                        print(dateLink);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      tooltip: 'Select a day from the calendar',
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      tooltip: 'Photo of the next day',
                      onPressed: () {
                        DateTime dt = DateTime.parse(dateLink);
                        setState(() {
                          dateLink = DateFormat('yyyy-MM-dd')
                                  .format(dt.add(const Duration(days: 1)))
                              as String;
                        });
                        changeDay(dateLink);
                        print(dateLink);
                      },
                    ),
                  ],
                ),
              ),
            ]),
    );
  }
}
