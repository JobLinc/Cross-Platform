class Skill {
  final String name;
  final int level;

  Skill({
    required this.name,
    required this.level,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] ?? '',
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
    };
  }
}