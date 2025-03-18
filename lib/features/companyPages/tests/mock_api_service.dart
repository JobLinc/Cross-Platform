import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class CompanyApiService {
  final String baseUrl;
  final http.Client client;

  CompanyApiService({required this.baseUrl, required this.client});

  // Fetch a company by ID
  Future<Company> getCompanyById(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/companies/$id'));

    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company');
    }
  }

  // Create a new company
  Future<Company> createCompany(Map<String, dynamic> companyData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(companyData),
    );

    if (response.statusCode == 201) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create company');
    }
  }
}

class Company {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String industry;
  final String owner;
  final String website;
  final List<String> admins;
  final String overview;
  final String logo;
  final String coverPhoto;
  final DateTime founded;
  final List<Location> locations;
  final int followers;
  final int employees;
  final List<String> jobs;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.industry,
    required this.owner,
    required this.website,
    required this.admins,
    required this.overview,
    required this.logo,
    required this.coverPhoto,
    required this.founded,
    required this.locations,
    required this.followers,
    required this.employees,
    required this.jobs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      industry: json['industry'],
      owner: json['owner'],
      website: json['website'],
      admins: List<String>.from(json['admins']),
      overview: json['overview'],
      logo: json['logo'],
      coverPhoto: json['coverPhoto'],
      founded: DateTime.parse(json['founded']),
      locations: List<Location>.from(
          json['locations'].map((x) => Location.fromJson(x))),
      followers: json['followers'],
      employees: json['employees'],
      jobs: List<String>.from(json['jobs']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Location {
  final String address;
  final String city;
  final String country;
  final bool primary;
  final String id;

  Location({
    required this.address,
    required this.city,
    required this.country,
    required this.primary,
    required this.id,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      country: json['country'],
      primary: json['primary'],
      id: json['id'],
    );
  }
}

class MockCompanyApiService extends Mock implements CompanyApiService {}
