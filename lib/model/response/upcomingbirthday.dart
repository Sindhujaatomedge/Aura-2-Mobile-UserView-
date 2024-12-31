class UpcomingBirthday {
  final String name;
  final String avatar;
  final String dateofbith;
  final String designation;

  UpcomingBirthday ({
  required this.name,
  required this.avatar,
  required this.dateofbith,
  required this.designation,

});
  factory UpcomingBirthday.fromJson(Map<String,dynamic> json){
    return UpcomingBirthday(
        name: json['name'] ?? '',
        avatar: json['avatar'] ?? '',
        dateofbith: json['dateofbirth'] ?? '',
        designation: json['designation']);
  }
  @override
  String toString() {
    return 'UpcomingBirthday( name: $name, avatar: $avatar, dateofbirth: $dateofbith, designation: $designation)';
  }
}