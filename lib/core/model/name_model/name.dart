import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'name.g.dart';

@JsonSerializable(explicitToJson: true)
class UserName {
  @JsonKey(name: "fName")
  final String? firstName;
  @JsonKey(name: "lName")
  final String? lastName;

  const UserName({this.firstName, this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserName.fromJson(Map<String, dynamic> json) {
    return _$UserNameFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserNameToJson(this);
  // String toJson() => json.encode(toMap());
}
