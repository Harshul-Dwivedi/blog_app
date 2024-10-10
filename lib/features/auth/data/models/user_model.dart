import 'package:blogger/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
  });

  ///basically we are asking for email,id,name through const. in model
  ///and passing it to super class user entity.

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }
  UserModel copyWith({
    String? email,
    String? id,
    String? name,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
