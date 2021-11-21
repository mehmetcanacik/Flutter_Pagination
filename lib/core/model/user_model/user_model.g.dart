// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      userId: json['userId'] as int? ?? 0,
      userAvatar: json['picture'] as String?,
      name: UserName.fromJson(json['name'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      email: json['email'] as String?,
      age: json['age'] as int,
      company: json['company'] as String?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'userId': instance.userId,
      'picture': instance.userAvatar,
      'name': instance.name,
      'isActive': instance.isActive,
      'email': instance.email,
      'age': instance.age,
      'company': instance.company,
    };
