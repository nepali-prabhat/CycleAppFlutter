
import 'dart:convert';

class UserModel {
    int id;
    String username;
    String email;
    String phoneNo;
    String address;
    DateTime createdAt;
    DateTime updatedAt;

    UserModel({
        this.id,
        this.username,
        this.email,
        this.phoneNo,
        this.address,
        this.createdAt,
        this.updatedAt,
    });

    factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserModel.fromMap(Map<String, dynamic> json) => new UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phoneNo: json["phone_no"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "phone_no": phoneNo,
        "address": address,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
