import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';

class Invitations {
  static List<Map<String, String>> pendingConnections = [
    {
      "id": "a1b2c3",
      "firstname": "omar",
      "lastname": "hassan",
      "title": "Mechatronics Engineer",
      "mutualConnections": "30",
      "timeAgo": "1 week ago"
    },
    {
      "id": "d4e5f6",
      "firstname": "mazen",
      "lastname": "ahmed",
      "title": "Communication and Computing",
      "mutualConnections": "58",
      "timeAgo": "1 week ago"
    },
    {
      "id": "g7h8i9",
      "firstname": "paula",
      "lastname": "isaac",
      "title": "Sophomore - Electrical Engineer",
      "mutualConnections": "78",
      "timeAgo": "1 week ago"
    },
    {
      "id": "j1k2l3",
      "firstname": "youssef",
      "lastname": "kamal",
      "title": "Software Developer",
      "mutualConnections": "45",
      "timeAgo": "2 days ago"
    },
    {
      "id": "m4n5o6",
      "firstname": "hana",
      "lastname": "saad",
      "title": "AI Researcher",
      "mutualConnections": "62",
      "timeAgo": "3 days ago"
    },
    {
      "id": "p7q8r9",
      "firstname": "omar",
      "lastname": "tarek",
      "title": "Data Scientist",
      "mutualConnections": "37",
      "timeAgo": "5 days ago"
    },
    {
      "id": "s1t2u3",
      "firstname": "laila",
      "lastname": "mostafa",
      "title": "Embedded Systems Engineer",
      "mutualConnections": "51",
      "timeAgo": "6 days ago"
    },
    {
      "id": "v4w5x6",
      "firstname": "karim",
      "lastname": "adel",
      "title": "Cybersecurity Analyst",
      "mutualConnections": "84",
      "timeAgo": "1 week ago"
    }
  ];
}

class PendingInvitation {
  final String userId;
  final String firstname;
  final String lastname;
  final String headline;
  final String profilePicture;
  final String connectionStatus; // Sent, Received, NotConnected
  final int mutualConnections;

  PendingInvitation({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.headline,
    required this.profilePicture,
    required this.connectionStatus,
    required this.mutualConnections,
  });

  factory PendingInvitation.fromJson(Map<String, dynamic> json) {
    return PendingInvitation(
      userId: json["userId"],
      firstname: json["firstname"],
      lastname: json["lastname"],
      headline: json["headline"],
      profilePicture: json["profilePicture"],
      connectionStatus: json["connectionStatus"], // "Sent" or "Received"
      mutualConnections: json["mutualConnections"], // Typo in JSON key retained
    );
  }
}
List<UserConnection> mockPendingInvitations = [
  UserConnection(
    userId: "7",
    firstname: "Olivia",
    lastname: "Taylor",
    headline: "Cybersecurity Analyst",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 6,
  ),
  UserConnection(
    userId: "8",
    firstname: "Liam",
    lastname: "Anderson",
    headline: "Blockchain Developer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 3,
  ),
  UserConnection(
    userId: "9",
    firstname: "Sophia",
    lastname: "Martinez",
    headline: "HR Specialist",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 4,
  ),
  UserConnection(
    userId: "10",
    firstname: "Ethan",
    lastname: "Johnson",
    headline: "Full Stack Developer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 5,
  ),
  UserConnection(
    userId: "11",
    firstname: "Emma",
    lastname: "White",
    headline: "Digital Marketing Expert",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 2,
  ),
  UserConnection(
    userId: "12",
    firstname: "Noah",
    lastname: "Williams",
    headline: "Machine Learning Engineer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 7,
  ),
  UserConnection(
    userId: "13",
    firstname: "Ava",
    lastname: "Brown",
    headline: "Graphic Designer",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 4,
  ),
  UserConnection(
    userId: "14",
    firstname: "James",
    lastname: "Miller",
    headline: "Cloud Solutions Architect",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 3,
  ),
  UserConnection(
    userId: "15",
    firstname: "Mia",
    lastname: "Garcia",
    headline: "Business Analyst",
    profilePicture: "https://www.example.com",
    connectionStatus: "Pending",
    mutualConnections: 5,
  ),
];
