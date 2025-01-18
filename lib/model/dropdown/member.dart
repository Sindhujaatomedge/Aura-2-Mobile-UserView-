class MemberDropdown {
  final String id;
  final String name;

  MemberDropdown({required this.id, required this.name});

  // Create a MemberDropdown object from a JSON map
  factory MemberDropdown.fromJson(Map<String, dynamic> json) {
    return MemberDropdown(
      id: json['userid'] ?? '',
      name: json['firstname'] ?? '',
    );
  }

  // Convert a MemberDropdown object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '(id: $id, name: $name)';
  }
}
