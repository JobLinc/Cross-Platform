// class Company{}
// class SalaryRange{}
// class Location{}



// class Job {
//   final String id;
//   final String title;
//   final String industry;
//   final Company company;
//   final String description;
//   final String workplace;
//   final String type;
//   final String experienceLevel;
//   final SalaryRange salaryRange;
//   final Location location;
//   final List<String> keywords; // from "keywords"
//   final List<String> skills; // from "skills"
//   final bool accepting;
//   final DateTime createdAt;

//   Job({
//     required this.id,
//     required this.title,
//     required this.industry,
//     required this.company,
//     required this.description,
//     required this.workplace,
//     required this.type,
//     required this.experienceLevel,
//     required this.salaryRange,
//     required this.location,
//     required this.keywords,
//     required this.skills,
//     required this.accepting,
//     required this.createdAt,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['id'] as String? ?? json['_id'] as String,
//       title: json['title'] as String,
//       industry: json['industry'] as String,
//       company: Company.fromJson(json['company'] as Map<String, dynamic>),
//       description: json['description'] as String,
//       workplace: json['workplace'] as String,
//       type: json['type'] as String,
//       experienceLevel: json['experienceLevel'] as String,
//       salaryRange:SalaryRange.fromJson(json['salaryRange'] as Map<String, dynamic>),
//       location: Location.fromJson(json['location'] as Map<String, dynamic>),
//       keywords: [],
//       skills: (json['skills'] as List<dynamic>?)
//               ?.map((e) => e as String)
//               .toList() ??
//           [],
//       accepting: json['accepting'] as bool? ?? false,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'industry': industry,
//       'company': company.toJson(),
//       'description': description,
//       'workplace': workplace,
//       'type': type,
//       'experienceLevel': experienceLevel,
//       'salaryRange': salaryRange.toJson(),
//       'location': location.toJson(),
//       //'keywords': keywords,
//       'skills': skills,
//       'accepting': accepting,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
// }

// class Company {
//   final String id;
//   final String name;
//   final String tagline;
//   final String industry;
//   final String overview;
//   final String urlSlug;
//   final String size;
//   final String logo;
//   final int followers;

//   Company({
//     required this.id,
//     required this.name,
//     required this.tagline,
//     required this.industry,
//     required this.overview,
//     required this.urlSlug,
//     required this.size,
//     required this.logo,
//     required this.followers,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['id'] as String? ?? json['_id'] as String,
//       name: json['name'] as String,
//       tagline: json['tagline'] as String,
//       industry: json['industry'] as String,
//       overview: json['overview'] as String,
//       urlSlug: json['urlSlug'] as String,
//       size: json['size'] as String,
//       logo: json['logo'] as String,
//       followers: json['followers'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'tagline': tagline,
//       'industry': industry,
//       'overview': overview,
//       'urlSlug': urlSlug,
//       'size': size,
//       'logo': logo,
//       'followers': followers,
//     };
//   }
// }

// class SalaryRange {
//   final String id;
//   final double min;
//   final double max;
//   final String currency;

//   SalaryRange({
//     required this.id,
//     required this.min,
//     required this.max,
//     required this.currency,
//   });

//   factory SalaryRange.fromJson(Map<String, dynamic> json) {
//     return SalaryRange(
//       id: json['id'] as String? ?? json['_id'] as String,
//       min: (json['from'] as num).toDouble(),
//       max: (json['to'] as num).toDouble(),
//       currency: json['currency'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'from': min,
//       'to': max,
//       'currency': currency,
//     };
//   }
// }

// class Location {
//   final String id;
//   final String address;
//   final String city;
//   final String country;

//   Location({
//     required this.id,
//     required this.address,
//     required this.city,
//     required this.country,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'] as String? ?? json['_id'] as String,
//       address: json['address'] as String,
//       city: json['city'] as String,
//       country: json['country'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'address': address,
//       'city': city,
//       'country': country,
//     };
//   }
// }


class Job {
  final String id;
  final String title;
  final String industry;
  final Company company;
  final String description;
  final String workplace;
  final String type;
  final String experienceLevel;
  final SalaryRange salaryRange;
  final Location location;
  final List<String> keywords;
  final List<String> skills;
  final bool accepting;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.title,
    required this.industry,
    required this.company,
    required this.description,
    required this.workplace,
    required this.type,
    required this.experienceLevel,
    required this.salaryRange,
    required this.location,
    required this.keywords,
    required this.skills,
    required this.accepting,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // Sometimes Mongo returns _id, sometimes id, so we .toString() everything
    final rawId = json['id'] ?? json['_id'];
    final id = rawId?.toString() ?? '';

    // Skills come in under "skills" or maybe "keywords"
    final skillsField = (json['skills'] ?? json['keywords']) as List<dynamic>?;
    final skills = skillsField
            ?.map((e) => e.toString())
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];

    // If you still want a separate keywords list, you can fill it here:
    final keywordsField = (json['keywords'] as List<dynamic>?) ??
        <dynamic>[];
    final keywords = keywordsField
            .map((e) => e.toString())
            .where((s) => s.isNotEmpty)
            .toList();

    return Job(
      id: id,
      title: json['title']?.toString() ?? '',
      industry: json['industry']?.toString() ?? '',
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      description: json['description']?.toString() ?? '',
      workplace: json['workplace']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      experienceLevel: json['experienceLevel']?.toString() ?? '',
      salaryRange:
          SalaryRange.fromJson(json['salaryRange'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      keywords: keywords,
      skills: skills,
      accepting: json['accepting'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'industry': industry,
        'company': company.toJson(),
        'description': description,
        'workplace': workplace,
        'type': type,
        'experienceLevel': experienceLevel,
        'salaryRange': salaryRange.toJson(),
        'location': location.toJson(),
        'keywords': keywords,
        'skills': skills,
        'accepting': accepting,
        'createdAt': createdAt.toIso8601String(),
      };
}

class Company {
  final String id;
  final String name;
  final String tagline;
  final String industry;
  final String overview;
  final String urlSlug;
  final String size;
  final String logo;
  final int followers;

  Company({
    required this.id,
    required this.name,
    required this.tagline,
    required this.industry,
    required this.overview,
    required this.urlSlug,
    required this.size,
    required this.logo,
    required this.followers,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['_id'];
    return Company(
      id: rawId.toString(),
      name: json['name']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
      industry: json['industry']?.toString() ?? '',
      overview: json['overview']?.toString() ?? '',
      urlSlug: json['urlSlug']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      logo: json['logo']?.toString() ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s',
      followers: (json['followers'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'industry': industry,
        'overview': overview,
        'urlSlug': urlSlug,
        'size': size,
        'logo': logo,
        'followers': followers,
      };
}

class SalaryRange {
  final String id;
  final double min;
  final double max;
  final String currency;

  SalaryRange({
    required this.id,
    required this.min,
    required this.max,
    required this.currency,
  });

  factory SalaryRange.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['_id'];
    return SalaryRange(
      id: rawId.toString(),
      min: (json['from'] as num).toDouble(),
      max: (json['to'] as num).toDouble(),
      currency: json['currency']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'from': min,
        'to': max,
        'currency': currency,
      };
}

class Location {
  final String id;
  final String address;
  final String city;
  final String country;

  Location({
    required this.id,
    required this.address,
    required this.city,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['_id'];
    return Location(
      id: rawId.toString(),
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'city': city,
        'country': country,
      };
}


// class Job {
//   String? id;
//   String? title;
//   String? industry;
//   Company? company;
//   String? description;
//   String? workplace;
//   String? type;
//   String? experienceLevel;
//   SalaryRange? salaryRange;
//   Location? location;
//   List<String>? keywords;
//   DateTime? createdAt;

//   Job({
//       this.id,
//       this.title,
//       this.industry,
//       this.company,
//       this.description,
//       this.workplace,
//       this.type,
//       this.experienceLevel,
//       this.salaryRange,
//       this.location,
//       this.keywords,
//       this.createdAt,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id:json["id"],
//       title: json['title'],
//       industry: json['industry'],
//       company: json['company'] != null ? Company.fromJson(json['company']) : null,
//       description: json['description'],
//       workplace: json['workplace'],
//       type: json['type'],
//       experienceLevel: json['experienceLevel'],
//       salaryRange: json['salaryRange'] != null ? SalaryRange.fromJson(json['salaryRange']) : null,
//       location: json['location'] != null ? Location.fromJson(json['location']) : null,
//       keywords: json['keywords'] != null ? List<String>.from(json['keywords']) : [],
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id':id,
//       'title': title,
//       'industry': industry,
//       'company': company?.toJson(),
//       'description': description,
//       'workplace': workplace,
//       'type': type,
//       'experienceLevel': experienceLevel,
//       'salaryRange': salaryRange?.toJson(),
//       'location': location?.toJson(),
//       'keywords': keywords,
//       'createdAt': createdAt?.toIso8601String(),
//     };
//   }
// }


// class Company {
//   String? name;
//   String? size;

//   Company({this.name, this.size});

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       name: json['name'],
//       size: json['size'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'size': size,
//     };
//   }
// }

// class SalaryRange {
//   double? min;
//   double? max;

//   SalaryRange({this.min, this.max});

//   factory SalaryRange.fromJson(Map<String, dynamic> json) {
//     return SalaryRange(
//       min: json['min'],
//       max: json['max'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'min': min,
//       'max': max,
//     };
//   }
// }


// class Location {
//   String? city;
//   String? country;

//   Location({this.city, this.country});

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       city: json['city'],
//       country: json['country'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'city': city,
//       'country': country,
//     };
//   }
// }

// List<Job> mockAppliedJobs=[
//     Job(
//     id:'10',
//     title: "Marketing Specialist",
//     industry: "Marketing",
//     company: Company(name: "AdWorks", size: "200 employees"),
//     description: "Create and implement marketing campaigns.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["SEO", "Content Marketing", "Social Media"],
//     createdAt: DateTime.now(),
//   ),
// ];

// List<Job> mockSavedJobs=[
//     Job(
//     id:'9',
//     title: "Communications Engineer",
//     industry: "Technology",
//     company: Company(name: "TechCorp", size: "500+ employees"),
//     description: "Develop and maintain software solutions.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 60000, max: 90000),
//     location: Location(city: "San Francisco", country: "USA"),
//     keywords: ["Flutter", "Dart", "Backend"],
//     createdAt: DateTime.now(),
//   ),
// ];

// List<Job> mockJobs = [
//   Job(
//     id: '1',
//     title: "Software Engineer",
//     industry: "Technology",
//     company: Company(name: "InnovateTech", size: "1000+ employees"),
//     description: "Design, develop, and maintain innovative software solutions.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 80000, max: 120000),
//     location: Location(city: "San Francisco", country: "USA"),
//     keywords: ["Java", "Spring", "Microservices"],
//     createdAt: DateTime.now().subtract(Duration(hours: 1)),
//   ),
//   Job(
//     id: '2',
//     title: "Digital Marketing Specialist",
//     industry: "Marketing",
//     company: Company(name: "AdVantage", size: "300 employees"),
//     description: "Plan and execute digital marketing campaigns to boost online presence.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 50000, max: 70000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["SEO", "Social Media", "Content Creation"],
//     createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   ),
//   Job(
//     id: '3',
//     title: "Mobile App Developer",
//     industry: "Technology",
//     company: Company(name: "AppWorks", size: "500+ employees"),
//     description: "Build and optimize high-quality mobile applications for Android and iOS.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior",
//     salaryRange: SalaryRange(min: 90000, max: 140000),
//     location: Location(city: "Austin", country: "USA"),
//     keywords: ["Flutter", "Dart", "iOS", "Android"],
//     createdAt: DateTime.now().subtract(Duration(hours: 3)),
//   ),
//   Job(
//     id: '4',
//     title: "Graphic Designer",
//     industry: "Design",
//     company: Company(name: "CreativeHub", size: "150 employees"),
//     description: "Create visual designs for marketing materials and digital assets.",
//     workplace: "Remote",
//     type: "Part-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "Los Angeles", country: "USA"),
//     keywords: ["Adobe Photoshop", "Illustrator", "InDesign"],
//     createdAt: DateTime.now().subtract(Duration(days: 1, hours: 2)),
//   ),
//   Job(
//     id: '5',
//     title: "Data Analyst",
//     industry: "Finance",
//     company: Company(name: "FinAnalytics", size: "800+ employees"),
//     description: "Analyze financial data and generate insightful reports.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 60000, max: 80000),
//     location: Location(city: "Chicago", country: "USA"),
//     keywords: ["SQL", "Python", "Data Visualization"],
//     createdAt: DateTime.now().subtract(Duration(days: 1, hours: 5)),
//   ),
//   Job(
//     id: '6',
//     title: "Human Resources Manager",
//     industry: "Human Resources",
//     company: Company(name: "PeopleFirst", size: "250 employees"),
//     description: "Manage recruitment, training, and employee relations.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior",
//     salaryRange: SalaryRange(min: 70000, max: 100000),
//     location: Location(city: "Seattle", country: "USA"),
//     keywords: ["Recruitment", "Employee Relations", "Training"],
//     createdAt: DateTime.now().subtract(Duration(days: 2)),
//   ),
//   Job(
//     id: '7',
//     title: "Product Manager",
//     industry: "Technology",
//     company: Company(name: "NextGen Products", size: "600+ employees"),
//     description: "Lead cross-functional teams to build and launch new products.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 85000, max: 115000),
//     location: Location(city: "Boston", country: "USA"),
//     keywords: ["Agile", "Scrum", "User Experience"],
//     createdAt: DateTime.now().subtract(Duration(days: 3, hours: 4)),
//   ),
//   Job(
//     id: '8',
//     title: "Cybersecurity Analyst",
//     industry: "Security",
//     company: Company(name: "SecureNet", size: "400+ employees"),
//     description: "Monitor and protect systems from cyber threats and attacks.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior",
//     salaryRange: SalaryRange(min: 95000, max: 130000),
//     location: Location(city: "Washington", country: "USA"),
//     keywords: ["Network Security", "Risk Assessment", "Compliance"],
//     createdAt: DateTime.now().subtract(Duration(days: 4, hours: 6)),
//   ),
//   Job(
//     id:'9',
//     title: "Communications Engineer",
//     industry: "Technology",
//     company: Company(name: "TechCorp", size: "500+ employees"),
//     description: "Develop and maintain software solutions.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 60000, max: 90000),
//     location: Location(city: "San Francisco", country: "USA"),
//     keywords: ["Flutter", "Dart", "Backend"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id:'10',
//     title: "Marketing Specialist",
//     industry: "Marketing",
//     company: Company(name: "AdWorks", size: "200 employees"),
//     description: "Create and implement marketing campaigns.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["SEO", "Content Marketing", "Social Media"],
//     createdAt: DateTime.now(),
//   ),
// ];