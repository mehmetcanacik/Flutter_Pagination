import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/model/user_model/user_model.dart';
import 'core/service/user_service.dart';
import 'core/widgets/user_widget.dart';

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
    isLoading = true;
    userList.addAll(await service.fetchUsers(_currentPage, _pageLimit));
    setState(() {
      isLoading = false;
    });
    if ((await service.fetchUsers(_currentPage, _pageLimit)).length <
        _pageLimit) {
      hasMoreData = false;
      return;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  Scaffold buildScaffold() {
    return Scaffold(
    appBar: AppBar(),
    body: buildBody(),
  );
  }

  Column buildBody() {
    return Column(
    children: <Widget>[
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _controller,
          child: buildListView(),
        ),
      ),
    ],
  );
  }

  ListView buildListView() {
    return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == userList.length) {
              return const CupertinoActivityIndicator();
            }
            var user = userList[index];
            return UserWidget(user: user);
          },
          itemCount: hasMoreData ? userList.length + 1 : userList.length,
        );
  }
}
