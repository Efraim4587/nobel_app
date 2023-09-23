import 'package:flutter/material.dart';

class LaureateDetailsScreen extends StatelessWidget {
  // You can pass data or parameters to this screen
  // For example, you might pass the details of a selected laureate

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laureate Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the details of the selected laureate here
            // Include their name, Nobel prize category, bio, etc.
          ],
        ),
      ),
    );
  }
}
