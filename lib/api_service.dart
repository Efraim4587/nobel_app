import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class ApiService {
  final String countriesApiUrl = 'https://api.nobelprize.org/v1/country.csv';
  final String laureatesApiUrl =
      'http://api.nobelprize.org/v1/laureate.csv?gender=All';

  Future<List<String>> fetchCountries() async {
    final response = await http.get(Uri.parse(countriesApiUrl));
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

  Future<List<Map<String, String?>>> fetchWinningCountries() async {
    final response = await http.get(Uri.parse(laureatesApiUrl));
    if (response.statusCode == 200) {
      final List<String> lines = response.body.split('\n');
      List<Map<String, String?>> countriesData = [];

      for (int i = 1; i < lines.length; i++) {
        final List<String> columns = lines[i].split(',');

        // Ensure there are at least 18 columns (0-based index)
        if (columns.length >= 18) {
          final String country = columns[19]; // bornCountry
          final String category = columns[13]; // category
          final String year = columns[12]; // year

          if (country.isNotEmpty && category.isNotEmpty && year.isNotEmpty) {
            countriesData.add({
              'countryName': country,
              'category': category,
              'year': year,
            });
          }
        }
      }

      return countriesData;
    } else {
      throw Exception('Failed to load data from the API');
    }
  }


  Future<Map<String, String?>> fetchCountryFlags(
      Set<String?> countryNames) async {
    Map<String, String?> countryFlags = {};

    for (String? countryName in countryNames) {
      if (countryName != null) {
        final countryCode = countryName.split(' ')[0];
        final flagAssetPath = 'assets/$countryCode.svg';

        try {
          final flagData = await rootBundle.loadString(flagAssetPath);
          countryFlags[countryName] = flagData;
        } catch (e) {
          // Handle errors, e.g., flag not found for a country
          countryFlags[countryName] = null;
        }
      }
    }

    return countryFlags;
  }
}
