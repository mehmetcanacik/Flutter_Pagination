import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_pagination/model/name.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@immutable
@JsonSerializable(explicitToJson: true)
class User with _$User {
  const factory User(
      {@Default(0) int userId,
      @JsonKey(name: "picture") String? userAvatar,
      @JsonKey(name: "name") required UserName name}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
