class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool membership;
  final String address;
  final String birthDate;
  final String createAt;
  final String neighbordhood;
  final String updateAt;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.membership,
    required this.email,
    required this.neighbordhood,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.createAt,
    required this.updateAt,
  });

  // Factory constructor to create a User from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      neighbordhood: json['neighbordhood'],
      membership: json['membership'],
      phone: json['phone'],
      address: json['address'],
      birthDate: json['birthDate'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'membership': membership,
      'neighbordhood': neighbordhood,
      'email': email,
      'phone': phone,
      'address': address,
      'birthDate': birthDate,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }
}
