class Connections {
  static List<Map<String, String>> connections = [
    {
      "id": "1a2b3c",
      "firstname": "boody",
      "lastname": "mustafa",
      "title": "Student at Cairo University",
      "connected_on": "2025-03-10"
    },
    {
      "id": "2d3e4f",
      "firstname": "ahmed",
      "lastname": "walaa",
      "title": "Mechatronics Engineering Student",
      "connected_on": "2025-02-28"
    },
    {
      "id": "3g4h5i",
      "firstname": "youssef",
      "lastname": "hamed",
      "title": "CSE Student at German University",
      "connected_on": "2024-12-15"
    },
    {
      "id": "4j5k6l",
      "firstname": "omar",
      "lastname": "ali",
      "title": "Software Engineer at TechCorp",
      "connected_on": "2024-11-05"
    },
    {
      "id": "5m6n7o",
      "firstname": "laila",
      "lastname": "mahmoud",
      "title": "Marketing Specialist at AdWorld",
      "connected_on": "2024-10-20"
    },
    {
      "id": "6p7q8r",
      "firstname": "hassan",
      "lastname": "ibrahim",
      "title": "Data Analyst at FinTech Inc.",
      "connected_on": "2024-09-12"
    },
    {
      "id": "7s8t9u",
      "firstname": "sara",
      "lastname": "kamel",
      "title": "UX Designer at Creative Studio",
      "connected_on": "2024-08-30"
    },
    {
      "id": "8v9w0x",
      "firstname": "mostafa",
      "lastname": "gaber",
      "title": "Project Manager at BuildIt",
      "connected_on": "2024-07-25"
    },
    {
      "id": "9y0z1a",
      "firstname": "nour",
      "lastname": "el-din",
      "title": "Biomedical Engineer",
      "connected_on": "2024-06-14"
    },
    {
      "id": "78erfe",
      "firstname": "kareem",
      "lastname": "saad",
      "title": "AI Researcher",
      "connected_on": "2024-05-03"
    },
  ];
}

class UserConnection {
  final String userId;
  final String firstname;
  final String lastname;
  final String headline;
  final String profilePicture;
  final String connectionStatus;
  final int mutualConnections;
  final DateTime? time_of_connections;

  UserConnection({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.headline,
    required this.profilePicture,
    required this.connectionStatus,
    required this.mutualConnections,
    this.time_of_connections,
  });

  factory UserConnection.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          print('Error parsing date: $dateValue - $e');
          return null;
        }
      }
      return null;
    }

    return UserConnection(
      userId: json["userId"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      headline: json["headline"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      connectionStatus: json["connectionStatus"] ?? "Connected",
      mutualConnections: json["mutualConnections"],
      time_of_connections: parseDate(json["time"]) ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "firstname": firstname,
      "lastname": lastname,
      "headline": headline,
      "profilePicture": profilePicture,
      "connectionStatus": connectionStatus,
      "mutualConnections": mutualConnections,
    };
  }
}

List<UserConnection> mockConnections = [
  UserConnection(
    userId: "1",
    firstname: "John",
    lastname: "Doe",
    headline: "Software Engineer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 5,
  ),
  UserConnection(
    userId: "2",
    firstname: "Jane",
    lastname: "Smith",
    headline: "Product Manager",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 2,
  ),
  UserConnection(
    userId: "3",
    firstname: "Alice",
    lastname: "Brown",
    headline: "UX Designer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 3,
  ),
  UserConnection(
    userId: "4",
    firstname: "Michael",
    lastname: "Johnson",
    headline: "Data Scientist",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 8,
  ),
  UserConnection(
    userId: "5",
    firstname: "Emily",
    lastname: "Davis",
    headline: "Marketing Specialist",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 1,
  ),
  UserConnection(
    userId: "6",
    firstname: "Robert",
    lastname: "Wilson",
    headline: "AI Researcher",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 4,
  ),
  UserConnection(
    userId: "7",
    firstname: "Daniel",
    lastname: "Martinez",
    headline: "Cybersecurity Analyst",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 6,
  ),
  UserConnection(
    userId: "8",
    firstname: "Sophia",
    lastname: "Taylor",
    headline: "Cloud Solutions Architect",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 5,
  ),
  UserConnection(
    userId: "9",
    firstname: "Christopher",
    lastname: "Anderson",
    headline: "Blockchain Developer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 2,
  ),
  UserConnection(
    userId: "10",
    firstname: "Isabella",
    lastname: "Hernandez",
    headline: "Business Intelligence Analyst",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 7,
  ),
  UserConnection(
    userId: "11",
    firstname: "Matthew",
    lastname: "White",
    headline: "Data Engineer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Connected",
    mutualConnections: 3,
  ),
];
