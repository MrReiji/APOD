// ignore_for_file: file_names

import 'package:http/http.dart' as http;
import "APOD_Data.dart";
import 'dart:async';
import 'dart:convert';

Future<APOD_Data> fetchAPODData() async {
  const url =
      "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2022-04-05";

  final response = await http.get(Uri.parse(url));

  // if (response.statusCode == 200) {
  // If the server did return a 200 OK response,
  // then parse the JSON.
  return APOD_Data.fromJson(jsonDecode(response.body));
}
  // else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
//     throw Exception('Failed to load APOD_Data');
//   }
// }
