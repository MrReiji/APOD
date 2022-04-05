import "package:flutter/material.dart";
import "APOD_Data.dart";
import "networkStuff.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NASA ASTRONOMY PICTURE OF THE DAY",
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: const Color.fromRGBO(118, 73, 254, 1)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<APOD_Data> futureAPODData;

  @override
  void initState() {
    super.initState();
    futureAPODData = fetchAPODData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: FutureBuilder<APOD_Data>(
                  future: futureAPODData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Image.network(
                        snapshot.data!.hdurl,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                //ignore: prefer_const_constructors
                                : Center(
                                    child: const CircularProgressIndicator(),
                                  ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              Expanded(
                //flex: 1,
                child: FutureBuilder<APOD_Data>(
                  future: futureAPODData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(snapshot.data!.title),
                          const SizedBox(height: 10),
                          Text(snapshot.data!.date),
                          const SizedBox(height: 10),
                          Text("Author: " + snapshot.data!.copyright),
                          const SizedBox(height: 10),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            tooltip: 'Add to favorites!',
                            onPressed: () {},
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: FutureBuilder<APOD_Data>(
              future: futureAPODData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Text(snapshot.data!.explanation);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Photo of the previous day',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                tooltip: 'Select a day from the calendar',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Photo of the next day',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
