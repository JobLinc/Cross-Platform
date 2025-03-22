import 'package:flutter/material.dart';

// class Company{}
// class SalaryRange{}
// class Location{}

class Job {
  int? id;
  String? title;
  String? industry;
  Company? company;
  String? description;
  String? workplace;
  String? type;
  String? experienceLevel;
  SalaryRange? salaryRange;
  Location? location;
  List<String>? keywords;
  DateTime? createdAt;

  Job({
      this.id,
      this.title,
      this.industry,
      this.company,
      this.description,
      this.workplace,
      this.type,
      this.experienceLevel,
      this.salaryRange,
      this.location,
      this.keywords,
      this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id:json["id"],
      title: json['title'],
      industry: json['industry'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
      description: json['description'],
      workplace: json['workplace'],
      type: json['type'],
      experienceLevel: json['experienceLevel'],
      salaryRange: json['salaryRange'] != null ? SalaryRange.fromJson(json['salaryRange']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      keywords: json['keywords'] != null ? List<String>.from(json['keywords']) : [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'industry': industry,
      'company': company?.toJson(),
      'description': description,
      'workplace': workplace,
      'type': type,
      'experienceLevel': experienceLevel,
      'salaryRange': salaryRange?.toJson(),
      'location': location?.toJson(),
      'keywords': keywords,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}


class Company {
  String? name;
  String? size;

  Company({this.name, this.size});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
    };
  }
}

class SalaryRange {
  double? min;
  double? max;

  SalaryRange({this.min, this.max});

  factory SalaryRange.fromJson(Map<String, dynamic> json) {
    return SalaryRange(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}


class Location {
  String? city;
  String? country;

  Location({this.city, this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
    };
  }
}


List<Job> mockJobs= [
  Job(
    id:1,
    title: "Software Engineer",
    industry: "Technology",
    company: Company(name: "TechCorp", size: "500+ employees"),
    description: "Develop and maintain software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 60000, max: 90000),
    location: Location(city: "San Francisco", country: "USA"),
    keywords: ["Flutter", "Dart", "Backend"],
    createdAt: DateTime.now(),
  ),
  Job(
    id:2,
    title: "Marketing Specialist",
    industry: "Marketing",
    company: Company(name: "AdWorks", size: "200 employees"),
    description: "Create and implement marketing campaigns.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(min: 40000, max: 60000),
    location: Location(city: "New York", country: "USA"),
    keywords: ["SEO", "Content Marketing", "Social Media"],
    createdAt: DateTime.now(),
  ),
  Job(
    id:3,
    title: "Software Engineer",
    industry: "Technology",
    company: Company(name: "TechCorp", size: "500+ employees"),
    description: "Develop and maintain software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 60000, max: 90000),
    location: Location(city: "San Francisco", country: "USA"),
    keywords: ["Flutter", "Dart", "Backend"],
    createdAt: DateTime.now(),
  ),
  Job(
    id:4,
    title: "Marketing Specialist",
    industry: "Marketing",
    company: Company(name: "AdWorks", size: "200 employees"),
    description: "Create and implement marketing campaigns.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(min: 40000, max: 60000),
    location: Location(city: "New York", country: "USA"),
    keywords: ["SEO", "Content Marketing", "Social Media"],
    createdAt: DateTime.now(),
  ),
  Job(
    id:5,
    title: "Software Engineer",
    industry: "Technology",
    company: Company(name: "TechCorp", size: "500+ employees"),
    description: "Develop and maintain software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 60000, max: 90000),
    location: Location(city: "San Francisco", country: "USA"),
    keywords: ["Flutter", "Dart", "Backend"],
    createdAt: DateTime.now(),
  ),
  Job(
    id:6,
    title: "Marketing Specialist",
    industry: "Marketing",
    company: Company(name: "AdWorks", size: "200 employees"),
    description: "Create and implement marketing campaigns.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(min: 40000, max: 60000),
    location: Location(city: "New York", country: "USA"),
    keywords: ["SEO", "Content Marketing", "Social Media"],
    createdAt: DateTime.now(),
  ),
];