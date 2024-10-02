class User {
  final String? uid;
  final String? email;
  final String? password;
  final String? role;
  final String? fullname;
  final String? contactNo;
  final String? cnic;
  final String? profilePic;

  User({
    this.uid = '',
    this.email,
    this.password,
    this.role,
    this.fullname,
    this.contactNo,
    this.cnic,
    this.profilePic = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': '',
      'email': email,
      'password': password,
      'role': role,
      'fullname': fullname,
      'contact_no': contactNo,
      'cnic': cnic,
      'profilePic': '',
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['_id'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      fullname: json['fullname'],
      contactNo: json['contact_no'],
      cnic: json['cnic'],
      profilePic: json['profilePic'],
    );
  }
}
