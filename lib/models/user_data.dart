class Membership {
  final bool active;
  final bool discount;

  Membership({
    required this.active,
    required this.discount,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      active: json['active'],
      discount: json['discount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'discount': discount,
    };
  }
}

class UserData {
  final double deliveryPrice;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Membership membership;
  final String address;
  final String? birthDate;
  final String createAt;
  final String neighbordhood;
  final String updateAt;

  UserData({
    required this.id,
    required this.deliveryPrice,
    required this.firstName,
    required this.lastName,
    required this.membership,
    required this.email,
    required this.neighbordhood,
    required this.phone,
    required this.address,
    this.birthDate,
    required this.createAt,
    required this.updateAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      deliveryPrice: json['deliveryPrice'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      neighbordhood: json['neighbordhood'],
      phone: json['phone'],
      address: json['address'],
      birthDate: json['birthDate'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      membership: Membership.fromJson(json['membership']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryPrice': deliveryPrice,
      'firstName': firstName,
      'lastName': lastName,
      'membership': membership.toJson(),
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
