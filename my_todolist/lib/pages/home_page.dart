import 'package:flutter/material.dart';
import 'package:my_todolist/const.dart';
import 'package:my_todolist/pages/todolist.dart';

import 'createtodolist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final tabs = const [Todolist(), CreateTodo()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primarycolor,
        unselectedItemColor: Colors.white,
        backgroundColor: darkcolor,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'all'),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: 'create'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
