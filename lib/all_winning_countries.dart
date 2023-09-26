import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nobel_app/api_service.dart';

class AllWinningCountriesScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  late Future<List<String>> countriesFuture;
  late Future<List<Map<String, String?>>> winningCountriesFuture;
  late Future<Map<String, String?>> countryFlags;

  AllWinningCountriesScreen({Key? key}) {
    countriesFuture = apiService.fetchCountries();
    winningCountriesFuture = apiService.fetchWinningCountries();
    countryFlags = loadCountryFlags();
  }

  Future<Map<String, String?>> loadCountryFlags() async {
    final countryNames = await countriesFuture;
    final flags = await apiService.fetchCountryFlags(countryNames.toSet());

    return flags;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Winning Countries'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          countriesFuture,
          winningCountriesFuture,
          countryFlags,
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<String> countries = (snapshot.data?[0] as List<String>?) ?? [];
            final List<Map<String, String?>> winningCountries = (snapshot.data?[1] as List<Map<String, String?>>?) ?? [];
            final Map<String, String?> flags = snapshot.data?[2] as Map<String, String?>? ?? {};

            return ListView.builder(
              itemCount: winningCountries.length,
              itemBuilder: (context, index) {
                if (index >= winningCountries.length) {
                  return const SizedBox();
                }
                final countryData = winningCountries[index];
                final countryName = countryData['countryName'];
                final category = countryData['category'];
                final year = countryData['year'];
                if (countryName == null || category == null || year == null) {
                  return SizedBox();
                }

                final countryCode = flags[countryName];

                final flagImagePath = countryCode != null
                    ? 'assets/flags/${countryCode.toLowerCase()}.svg'
                    : 'assets/flags/il.svg';

                return ListTile(
                  leading: SvgPicture.asset(
                    flagImagePath,
                    width: 50,
                    height: 30,
                  ),
                  title: Text('$countryName - $year'),
                  subtitle: Text('Category: $category'),
                );

              },
            );
          }
        },
      ),
    );
  }
}
