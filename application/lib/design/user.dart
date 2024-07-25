// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  int id;
  String userName;
  String profilePhoto;
  bool isSuperVisor;
  bool isShiftManager;
  String firstName;
  String lastName;

  User({
    required this.id,
    required this.userName,
    required this.profilePhoto,
    required this.isSuperVisor,
    required this.isShiftManager,
    required this.firstName,
    required this.lastName,
  });

  User copyWith({
    int? id,
    String? userName,
    String? profilePhoto,
    bool? isSuperVisor,
    bool? isShiftManager,
    String? firstName,
    String? lastName,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isSuperVisor: isSuperVisor ?? this.isSuperVisor,
      isShiftManager: isShiftManager ?? this.isShiftManager,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': userName,
      'profile': profilePhoto,
      'is_supervisor': isSuperVisor,
      'is_shift_manager': isShiftManager,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      userName: map['username'] as String,
      profilePhoto: map['profile'] as String,
      isSuperVisor: map['is_supervisor'] as bool,
      isShiftManager: map['is_shift_manager'] as bool,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, profilePhoto: $profilePhoto, isSuperVisor: $isSuperVisor, isShiftManager: $isShiftManager, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.profilePhoto == profilePhoto &&
        other.isSuperVisor == isSuperVisor &&
        other.isShiftManager == isShiftManager &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        profilePhoto.hashCode ^
        isSuperVisor.hashCode ^
        isShiftManager.hashCode ^
        firstName.hashCode ^
        lastName.hashCode;
  }
}
