import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_pagination/model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Dio dio;
  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () async {
              final responseBody =
                  await dio.get("http://192.168.1.22:3000/getApi/Users");
              var list = (responseBody.data as List)
                  .map((user) => User.fromJson(user))
                  .cast<User>()
                  .toList();
              log(list.length.toString());
            },
            child: Text("Fetch Users",
                style: Theme.of(context).textTheme.headline2),
          )
        ],
      ),
    );
  }
}

// class User {
//   final int? userId;
//   final String? picture;

//   const User({this.userId, this.picture});
//   factory User.fromJson(Map<String, dynamic>? json) {
//     if (json != null) {
//       return User(userId: json['userId'], picture: json['picture']);
//     }
//     return const User();
//   }
//   Map<String, dynamic> toJson() {
//     return {"userId": userId, "picture": picture};
//   }
// }
