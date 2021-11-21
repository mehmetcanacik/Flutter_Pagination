import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_pagination/core/model/user_model/user_model.dart';
import 'package:user_pagination/core/service/user_service.dart';
import 'package:user_pagination/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Pagination',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
