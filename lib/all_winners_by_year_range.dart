import 'package:flutter/material.dart';

class AllWinnersByYearRangeScreen extends StatefulWidget {
  @override
  _AllWinnersByYearRangeScreenState createState() => _AllWinnersByYearRangeScreenState();
}

class _AllWinnersByYearRangeScreenState extends State<AllWinnersByYearRangeScreen> {
  DateTime selectedStartDate = DateTime(1901);
  DateTime selectedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Winners by Year Range'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select a start date and end date:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Add date picker widgets to select start and end dates here
            // Use selectedStartDate and selectedEndDate for date selection
            // Validate that the selected start date is not before 1901 and not after the current date
          ],
        ),
      ),
    );
  }
}
