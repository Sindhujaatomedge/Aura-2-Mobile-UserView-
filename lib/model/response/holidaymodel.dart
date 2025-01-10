class HolidayModel {
  final String orgId;
 final  String id;
 final String name;
 final  String description;
final  DateTime fromDate;
final  DateTime toDate;
 final bool mandatory;
 final ApplicableFor applicableFor;

  HolidayModel({
    required this.orgId,
    required this.id,
    required this.name,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.mandatory,
    required this.applicableFor,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      orgId: json['orgid'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fromDate: DateTime.parse(json['fromdate'] ?? ''),
      toDate: DateTime.parse(json['todate'] ?? ''),
      mandatory: json['mandatory'] ?? '',
      applicableFor: ApplicableFor.fromJson(json['applicablefor'] ?? ''),
    );
  }
}

class ApplicableFor {
  List<String> location;

  ApplicableFor({required this.location});

  factory ApplicableFor.fromJson(Map<String, dynamic> json) {
    return ApplicableFor(
      location: List<String>.from(json['location'] ?? []),
    );
  }
}
