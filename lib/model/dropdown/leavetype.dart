class LeaveTypeDropdownValue {
  final String id;
  final String name;

  LeaveTypeDropdownValue({required this.id, required this.name});

  // Create a LeaveTypeDropdownValue object from a JSON map
  factory LeaveTypeDropdownValue.fromJson(Map<String, dynamic> json) {
    return LeaveTypeDropdownValue(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  // Convert a LeaveTypeDropdownValue object to JSON map
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
