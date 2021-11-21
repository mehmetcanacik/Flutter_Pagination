
import 'package:flutter/material.dart';
import 'package:user_pagination/core/model/user_model/user_model.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: Text(user.userId.toString()),
          title: Text(user.email ?? "empty email")),
    );
  }
}
