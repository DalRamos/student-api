class Student {
  final String firstName;
  final String lastName;
  final String course;
  final bool enrolled;

  Student({
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.enrolled,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'enrolled': enrolled,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      firstName: json['firstName'],
      lastName: json['lastName'],
      course: json['course'],
      enrolled: json['enrolled'],
    );
  }
}
