import 'package:flutter/material.dart';

class WinnersByCountryScreen extends StatelessWidget {
  final String selectedCountry;

  WinnersByCountryScreen({required this.selectedCountry, required String country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winners from $selectedCountry'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'List of Nobel laureates from $selectedCountry',
              style: TextStyle(fontSize: 18),
            ),
            // Add your list of laureates here based on the selected country
          ],
        ),
      ),
    );
  }
}
