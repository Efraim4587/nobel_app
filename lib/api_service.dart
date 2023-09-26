import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

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

      // Read the country code data from the CSV
      final List<Map<String, String?>> countryCodes = await fetchCountryCodes(); // Corrected type

      for (int i = 1; i < lines.length; i++) {
        final List<String> columns = lines[i].split(',');
        if (columns.length >= 18) {
          String country = columns[19];
          final String category = columns[13];
          final String year = columns[12];

          String countryCode = '';

          if(country.contains("now")){
            int start = country.indexOf("now") + 4;
            int end = country.indexOf(")");
            country = country.substring(start, end);
          }
          
          if (country.isNotEmpty && category.isNotEmpty && year.isNotEmpty) {
            for (final pair in countryCodes) {
              if (pair.values.first == country) {
                countryCode = pair.values.last ?? '';
              }
            }
            countriesData.add({
              'countryName': country,
              'category': category,
              'year': year,
              'countryCode': countryCode,
            });
          }
        }
      }

      return countriesData;
    } else {
      throw Exception('Failed to load data from the API');
    }
  }



  Future<List<Map<String, String?>>> fetchCountryCodes() async {
    final response = await http.get(Uri.parse(countriesApiUrl));
    if (response.statusCode == 200) {
      final List<String> lines = response.body.split('\n');
      List<Map<String, String?>> countryCodes = [];

      for (int i = 1; i < lines.length; i++) {
        final List<String> columns = lines[i].split(',');
        if (columns.length >= 2) {
          final String countryName = columns[0];
          final String countryCode = columns[1];

          if (countryName.isNotEmpty && countryCode.isNotEmpty) {
            countryCodes.add({
              'countryName': countryName,
              'countryCode': countryCode,
            });
          }
        }
      }
      return countryCodes;
    } else {
      throw Exception('Failed to load country code data from the API');
    }
  }

  Future<Map<String, String?>> fetchCountryFlags(
      Set<String?> countryNames) async {
    Map<String, String?> countryFlags = {};

    // Fetch the CSV data from the provided URL
    final response = await http.get(Uri.parse(countriesApiUrl));

    if (response.statusCode == 200) {
      final List<String> countryLines = response.body.split('\n');

      for (int i = 1; i < countryLines.length; i++) {
        final List<String> columns = countryLines[i].split(',');

        if (columns.isNotEmpty) {
          final String countryName = columns[0];
          final String countryCode = columns[1];

          if (countryName.isNotEmpty && countryCode.isNotEmpty) {
            countryFlags[countryName] = countryCode;
          }
        }
      }
    } else {
      throw Exception('Failed to load country flags from the API');
    }

    return countryFlags;
  }
}
