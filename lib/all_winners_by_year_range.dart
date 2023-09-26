import 'package:flutter/material.dart';

class AllWinnersByYearRangeScreen extends StatefulWidget {
  final int startYear; // Add startYear as a parameter
  final int endYear; // Add endYear as a parameter

  AllWinnersByYearRangeScreen({
    required this.startYear,
    required this.endYear,
  });

  @override
  _AllWinnersByYearRangeScreenState createState() =>
      _AllWinnersByYearRangeScreenState();
}

class _AllWinnersByYearRangeScreenState
    extends State<AllWinnersByYearRangeScreen> {
  // Your implementation for this screen
  // You can access widget.startYear and widget.endYear to get the values
  // passed from the previous screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winners from ${widget.startYear} to ${widget.endYear}'),
      ),
      body: Center(
        // Your content here
      ),
    );
  }
}
