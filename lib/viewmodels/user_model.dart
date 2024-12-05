// models/user_data_model.dart
class UserDataModel {
  final bool accountType;
  final String bio;
  final String dateOfBirth;
  final String email;
  final String fullName;
  final bool isPhoneVisible;
  final String phone;
  final String? profilePictureUrl;
  final int relationshipStatus;
  final int sex;
  final String uid;

  UserDataModel({
    required this.accountType,
    required this.bio,
    required this.dateOfBirth,
    required this.email,
    required this.fullName,
    required this.isPhoneVisible,
    required this.phone,
    required this.profilePictureUrl,
    required this.relationshipStatus,
    required this.sex,
    required this.uid,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> data) {
    return UserDataModel(
      accountType: data['accountType'] ?? false,
      bio: data['bio'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      isPhoneVisible: data['isPhoneVisible'] ?? false,
      phone: data['phone'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
      relationshipStatus: data['relationshipStatus'] ?? 0,
      sex: data['sex'] ?? 0,
      uid: data['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountType': accountType,
      'bio': bio,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'fullName': fullName,
      'isPhoneVisible': isPhoneVisible,
      'phone': phone,
      'profilePictureUrl': profilePictureUrl,
      'relationshipStatus': relationshipStatus,
      'sex': sex,
      'uid': uid,
    };
  }
}
