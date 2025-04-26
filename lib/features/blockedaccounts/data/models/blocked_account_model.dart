class BlockedAccountModel {
  BlockedAccountModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.mutualConnections,
  });
  final String userId;
  final String firstName;
  final String lastName;
  final int mutualConnections;

  factory BlockedAccountModel.fromJson(Map<String, dynamic> json) {
    return BlockedAccountModel(
      userId: json['userId'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      mutualConnections: json['mutualConnections'],
    );
  }
}
