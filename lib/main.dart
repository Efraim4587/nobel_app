import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'all_winning_countries.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nobel App',
      theme: ThemeData(
        primaryColor: const Color(0xFF3366FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        typography: Typography.material2018(),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFCCCCCC),
        ).copyWith(
          background: const Color(0xFFF5F5F5),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCountrySelection = false;
  bool showYearSelection = false;
  List<String> countries = [];
  List<String> startYears = [];
  List<String> endYears = [];
  String selectedStartYear = '1901';
  String selectedEndYear = DateTime.now().year.toString();

  final ApiService apiService = ApiService();
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    initializeYears();
  }

  void initializeYears() {
    for (int year = 1901; year <= DateTime.now().year; year++) {
      startYears.add(year.toString());
      endYears.add(year.toString());
    }
    endYears = endYears.reversed.toList();
  }

  void toggleCountrySelection() {
    setState(() {
      showCountrySelection = !showCountrySelection;
      showYearSelection = false;
    });
  }

  void toggleYearSelection() {
    setState(() {
      showYearSelection = !showYearSelection;
      showCountrySelection = false;
    });
  }

  void hideAllSelection() {
    setState(() {
      showYearSelection = false;
      showCountrySelection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nobel App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isHovered ? 20.0 : 0.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Image.asset(
                  'assets/nobel_prize_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Nobel App!',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                toggleCountrySelection();
                if (showCountrySelection) {
                  fetchCountryList();
                }
              },
              child: const Text('Winners by Country'),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: showCountrySelection ? null : 0,
              child: showCountrySelection
                  ? Column(
                children: [
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    hint: const Text('Choose a country'),
                    value: null,
                    onChanged: (newValue) {},
                    items: countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                  ),
                ],
              )
                  : null,
            ),
            ElevatedButton(
              onPressed: () {
                toggleYearSelection();
              },
              child: const Text('Winners by Year Range'),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: showYearSelection ? null : 0,
              child: showYearSelection
                  ? Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Select start year:',
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: selectedStartYear,
                    onChanged: (newValue) {
                      setState(() {
                        selectedStartYear = newValue!;
                      });
                    },
                    items: startYears.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select end year:',
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: selectedEndYear,
                    onChanged: (newValue) {
                      setState(() {
                        selectedEndYear = newValue!;
                      });
                    },
                    items: endYears.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                  ),
                ],
              )
                  : null,
            ),
            ElevatedButton(
              onPressed: () {
                hideAllSelection();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllWinningCountriesScreen(),
                  ),
                );
              },
              child: const Text('Winning Countries'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCountryList() async {
    try {
      final List<String> countryList = await apiService.fetchCountries();
      setState(() {
        countries = countryList;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching country list: $e');
      }
    }
  }
}
