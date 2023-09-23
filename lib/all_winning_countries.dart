import 'package:flutter/material.dart';

class AllWinningCountriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Winning Countries'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'List of all countries that have Nobel laureates:',
              style: TextStyle(fontSize: 18),
            ),
            // Add your list of all winning countries here
          ],
        ),
      ),
    );
  }
}
