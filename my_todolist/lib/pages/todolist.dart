import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_todolist/pages/update_todolist.dart';

import '../const.dart';

class Todolist extends StatefulWidget {
  const Todolist({Key? key}) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getAllList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        title: Text(appName,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: darkcolor,
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          return data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Boxinfo(
                        title: data[index]["title"],
                        detail: data[index]["detail"],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateTodolist(
                                v1: data[index]["id"],
                                v2: data[index]["title"],
                                v3: data[index]["detail"],
                              ),
                            )).then((value) {
                          setState(() {
                            getAllList();
                          });
                        });
                      },
                    );
                  },
                  itemCount: data.length,
                );
        },
        future: getAllList(),
      ),
    );
  }

  Future getAllList() async {
    var url = Uri.http(apiAuthority, '/api/all-todolist/');
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    return result;
  }
}

class Boxinfo extends StatelessWidget {
  const Boxinfo({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Container(
        height: size.height * 0.15,
        decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(40)),
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.center,
              colors: [
                secondarycolor,
                primarycolor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(.38),
                offset: const Offset(0, 2),
                blurRadius: 5,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
