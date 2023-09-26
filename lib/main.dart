import 'package:flutter/material.dart';
import 'package:nobel_app/winners_by_country.dart';

import 'all_winners_by_year_range.dart';
import 'all_winning_countries.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCountrySelection = false;
  bool showYearSelection = false;
  String selectedCountry = 'Select a country';
  String? selectedStartYear;
  String selectedEndYear = 'Select an end year';

  final ApiService apiService = ApiService();

  void toggleCountrySelection() {
    setState(() {
      showCountrySelection = !showCountrySelection;
      showYearSelection = false;
      selectedStartYear = null;
      selectedEndYear = 'Select an end year';
    });
  }

  void toggleYearSelection() {
    setState(() {
      showYearSelection = !showYearSelection;
      showCountrySelection = false;
      selectedCountry = 'Select a country';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nobel App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150), // Added space
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect( // Added a ClipRRect for image border radius
                  borderRadius: BorderRadius.circular(18.0),
                  child: Image.asset(
                    'assets/nobel_prize_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Nobel App!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
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
              ElevatedButton(
                onPressed: () {
                  hideAllSelection();
                  toggleCountrySelection(); // Toggle country selection
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
                    const Text(
                      'Select a country:',
                      style: TextStyle(fontSize: 18),
                    ),
                    FutureBuilder<List<String>>(
                      future: apiService.fetchCountries(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No countries available.');
                        } else {
                          return DropdownButton<String>(
                            hint: const Text('Select a country'), // Default text
                            value: selectedCountry,
                            onChanged: (newValue) {
                              if (newValue != null &&
                                  newValue != 'Select a country') {
                                setState(() {
                                  selectedCountry = newValue;
                                });
                                // Navigate to Winners by Country screen with the selected country
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WinnersByCountryScreen(
                                          country: selectedCountry,
                                          selectedCountry: '',
                                        ),
                                  ),
                                );
                              }
                            },
                            items: [
                              const DropdownMenuItem<String>(
                                value: 'Select a country', // Default text
                                child: Text('Select a country'),
                              ),
                              ...snapshot.data!.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(country),
                                );
                              }).toList(),
                            ],
                          );
                        }
                      },
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
                    // Dropdown for selecting commencement year
                    if (!showCountrySelection)
                      DropdownButton<String>(
                        hint: const Text('Select a start year'), // Default text
                        value: selectedStartYear,
                        onChanged: (newValue) {
                          if (newValue != null &&
                              newValue != 'Select a start year') {
                            setState(() {
                              selectedStartYear = newValue;
                              selectedEndYear = 'Select an end year';
                            });
                          }
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: 'Select a start year', // Unique value
                            child: Text('Select a start year'),
                          ),
                          ...List.generate(
                            DateTime.now().year - 1900,
                                (index) =>
                                (DateTime.now().year - index).toString(),
                          ).map((year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(year),
                            );
                          }).toList(),
                        ],
                      ),
                    const SizedBox(height: 20),
                    if (selectedStartYear != null)
                      Column(
                        children: [
                          DropdownButton<String>(
                            hint: const Text('Select an end year'), // Default text
                            value: selectedEndYear,
                            onChanged: (newValue) {
                              if (newValue != null &&
                                  newValue != 'Select an end year') {
                                setState(() {
                                  selectedEndYear = newValue;
                                });
                              }
                            },
                            items: [
                              const DropdownMenuItem<String>(
                                value: 'Select an end year', // Unique value
                                child: Text('Select an end year'),
                              ),
                              ...List.generate(
                                DateTime.now().year -
                                    int.parse(selectedStartYear!) +
                                    1,
                                    (index) =>
                                    (int.parse(selectedStartYear!) +
                                        index)
                                        .toString(),
                              ).map((year) {
                                return DropdownMenuItem<String>(
                                  value: year.toString(),
                                  child: Text(year.toString()),
                                );
                              }).toList(),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedStartYear != null &&
                                  selectedEndYear != 'Select an end year') {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AllWinnersByYearRangeScreen(
                                          startYear:
                                          int.parse(selectedStartYear!),
                                          endYear: int.parse(selectedEndYear),
                                        ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.blue.withOpacity(0.8), // Slightly lighter color
                            ),
                            child: const Text('Show Winners'),
                          ),
                        ],
                      ),
                  ],
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hideAllSelection() {
    setState(() {
      showCountrySelection = false;
      showYearSelection = false;
    });
  }
}
