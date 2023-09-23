import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiUrl = 'https://api.nobelprize.org/v1/country.csv'; // Use the correct API URL

  Future<List<String>> fetchCountries() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<String> countryLines = response.body.split('\n');
      if (countryLines.length > 1) {
        // Extract the country names from the CSV data
        List<String> countries = [];
        for (int i = 1; i < countryLines.length; i++) {
          final List<String> columns = countryLines[i].split(',');
          if (columns.isNotEmpty) {
            final String countryName = columns[0];
            countries.add(countryName);
          }
        }
        return countries;
      } else {
        throw Exception('No country data found in the API response');
      }
    } else {
      throw Exception('Failed to load country data from the API');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Country List'),
        ),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: ApiService().fetchCountries(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}