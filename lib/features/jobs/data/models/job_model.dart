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

List<Job> mockAppliedJobs=[
    Job(
    id:10,
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

List<Job> mockSavedJobs=[
    Job(
    id:9,
    title: "Communications Engineer",
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
];

List<Job> mockJobs = [
  Job(
    id: 1,
    title: "Software Engineer",
    industry: "Technology",
    company: Company(name: "InnovateTech", size: "1000+ employees"),
    description: "Design, develop, and maintain innovative software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 80000, max: 120000),
    location: Location(city: "San Francisco", country: "USA"),
    keywords: ["Java", "Spring", "Microservices"],
    createdAt: DateTime.now().subtract(Duration(hours: 1)),
  ),
  Job(
    id: 2,
    title: "Digital Marketing Specialist",
    industry: "Marketing",
    company: Company(name: "AdVantage", size: "300 employees"),
    description: "Plan and execute digital marketing campaigns to boost online presence.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(min: 50000, max: 70000),
    location: Location(city: "New York", country: "USA"),
    keywords: ["SEO", "Social Media", "Content Creation"],
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Job(
    id: 3,
    title: "Mobile App Developer",
    industry: "Technology",
    company: Company(name: "AppWorks", size: "500+ employees"),
    description: "Build and optimize high-quality mobile applications for Android and iOS.",
    workplace: "Onsite",
    type: "Full-time",
    experienceLevel: "Senior",
    salaryRange: SalaryRange(min: 90000, max: 140000),
    location: Location(city: "Austin", country: "USA"),
    keywords: ["Flutter", "Dart", "iOS", "Android"],
    createdAt: DateTime.now().subtract(Duration(hours: 3)),
  ),
  Job(
    id: 4,
    title: "Graphic Designer",
    industry: "Design",
    company: Company(name: "CreativeHub", size: "150 employees"),
    description: "Create visual designs for marketing materials and digital assets.",
    workplace: "Remote",
    type: "Part-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 40000, max: 60000),
    location: Location(city: "Los Angeles", country: "USA"),
    keywords: ["Adobe Photoshop", "Illustrator", "InDesign"],
    createdAt: DateTime.now().subtract(Duration(days: 1, hours: 2)),
  ),
  Job(
    id: 5,
    title: "Data Analyst",
    industry: "Finance",
    company: Company(name: "FinAnalytics", size: "800+ employees"),
    description: "Analyze financial data and generate insightful reports.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(min: 60000, max: 80000),
    location: Location(city: "Chicago", country: "USA"),
    keywords: ["SQL", "Python", "Data Visualization"],
    createdAt: DateTime.now().subtract(Duration(days: 1, hours: 5)),
  ),
  Job(
    id: 6,
    title: "Human Resources Manager",
    industry: "Human Resources",
    company: Company(name: "PeopleFirst", size: "250 employees"),
    description: "Manage recruitment, training, and employee relations.",
    workplace: "Onsite",
    type: "Full-time",
    experienceLevel: "Senior",
    salaryRange: SalaryRange(min: 70000, max: 100000),
    location: Location(city: "Seattle", country: "USA"),
    keywords: ["Recruitment", "Employee Relations", "Training"],
    createdAt: DateTime.now().subtract(Duration(days: 2)),
  ),
  Job(
    id: 7,
    title: "Product Manager",
    industry: "Technology",
    company: Company(name: "NextGen Products", size: "600+ employees"),
    description: "Lead cross-functional teams to build and launch new products.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(min: 85000, max: 115000),
    location: Location(city: "Boston", country: "USA"),
    keywords: ["Agile", "Scrum", "User Experience"],
    createdAt: DateTime.now().subtract(Duration(days: 3, hours: 4)),
  ),
  Job(
    id: 8,
    title: "Cybersecurity Analyst",
    industry: "Security",
    company: Company(name: "SecureNet", size: "400+ employees"),
    description: "Monitor and protect systems from cyber threats and attacks.",
    workplace: "Onsite",
    type: "Full-time",
    experienceLevel: "Senior",
    salaryRange: SalaryRange(min: 95000, max: 130000),
    location: Location(city: "Washington", country: "USA"),
    keywords: ["Network Security", "Risk Assessment", "Compliance"],
    createdAt: DateTime.now().subtract(Duration(days: 4, hours: 6)),
  ),
  Job(
    id:9,
    title: "Communications Engineer",
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
    id:10,
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