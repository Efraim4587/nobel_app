import 'package:flutter/material.dart';

class LaureatesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nobel Laureates List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the list of Nobel laureates here
            // You can use ListView.builder or other widgets
            // to display a dynamic list of laureates
          ],
        ),
      ),
    );
  }
}
