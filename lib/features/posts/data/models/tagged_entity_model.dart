class TaggedEntity {
  final String id;
  final int index;

  TaggedEntity({
    required this.id,
    required this.index,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
    };
  }

  factory TaggedEntity.fromJson(Map<String, dynamic> json) {
    // Check if this is a company tag by looking for a name field or type indicator
    if (json.containsKey('name') ||
        (json.containsKey('type') && json['type'] == 'company')) {
      return TaggedCompany(
        id: json['id'],
        index: json['index'],
        name: json['name'] ?? 'Unknown Company',
      );
    } else {
      // Handle user tags with potentially incomplete information
      String name = '';

      // Try to get name from various possible sources in the JSON
      if (json.containsKey('name')) {
        name = json['name'];
      } else if (json.containsKey('username')) {
        name = json['username'];
      } else if (json.containsKey('firstname') &&
          json.containsKey('lastname')) {
        name = '${json['firstname']} ${json['lastname']}';
      } else {
        name = 'Unknown User';
      }

      return TaggedUser(
        id: json['id'],
        index: json['index'],
        name: name,
      );
    }
  }
}

class TaggedUser extends TaggedEntity {
  final String name; // Used for display purposes

  TaggedUser({
    required String id,
    required int index,
    required this.name,
  }) : super(id: id, index: index);

  factory TaggedUser.fromJson(Map<String, dynamic> json) {
    String name = '';

    // Try to get name from various possible sources in the JSON
    if (json.containsKey('name')) {
      name = json['name'];
    } else if (json.containsKey('username')) {
      name = json['username'];
    } else if (json.containsKey('firstname') && json.containsKey('lastname')) {
      name = '${json['firstname']} ${json['lastname']}';
    } else {
      name = 'Unknown User';
    }

    return TaggedUser(
      id: json['id'],
      index: json['index'],
      name: name,
    );
  }
}

class TaggedCompany extends TaggedEntity {
  final String name; // Used for display purposes

  TaggedCompany({
    required String id,
    required int index,
    required this.name,
  }) : super(id: id, index: index);

  factory TaggedCompany.fromJson(Map<String, dynamic> json) {
    return TaggedCompany(
      id: json['id'],
      index: json['index'],
      name: json['name'] ?? 'Unknown Company',
    );
  }
}
