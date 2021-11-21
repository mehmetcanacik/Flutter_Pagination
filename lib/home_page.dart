import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_pagination/core/service/user_service.dart';
import 'core/model/user_model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService service = UserService();
  List<User> userList = [];
  bool hasMoreData = true;
  bool isLoading = false;
  late ScrollController _controller;
  int _currentPage = 1;

  final int _pageLimit = 10;
  @override
  void initState() {
    super.initState();
    fetchUsers();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        loadMoreData();
      }
    });
  }

  fetchUsers() async {
    try {
      userList = await service.fetchUsers(_currentPage, _pageLimit);
    } catch (e) {
      log("Hata : " + e.toString());
    }
    setState(() {});
  }

  void loadMoreData() async {
    if (!hasMoreData) {
      setState(() {});
      return;
    }
    if (isLoading) {
      return;
    }
    _currentPage += 1;
    log("CurrentPage : $_currentPage");
    isLoading = true;
    log("hasMore true Veri geldi");
    userList.addAll(await service.fetchUsers(_currentPage, _pageLimit));
    setState(() {
      isLoading = false;
    });
    if ((await service.fetchUsers(_currentPage, _pageLimit)).length <
        _pageLimit) {
      log("hasrMore False");
      hasMoreData = false;
      return;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == userList.length) {
                    return const CupertinoActivityIndicator();
                  }
                  var user = userList[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        leading: Text(user.userId.toString()),
                        title: Text(user.email ?? "email")),
                  );
                },
                itemCount: hasMoreData ? userList.length + 1 : userList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
