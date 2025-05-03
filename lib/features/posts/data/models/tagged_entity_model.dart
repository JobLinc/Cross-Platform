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
    return TaggedEntity(
      id: json['id'],
      index: json['index'],
    );
  }
}

class TaggedUser extends TaggedEntity {
  final String name; // Used for display purposes

  TaggedUser({
    required String id,
    required int index,
    required this.name,
  }) : super(id: id, index: index);
}

class TaggedCompany extends TaggedEntity {
  final String name; // Used for display purposes

  TaggedCompany({
    required String id,
    required int index,
    required this.name,
  }) : super(id: id, index: index);
}
