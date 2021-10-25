// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import '../const.dart';

class UpdateTodolist extends StatefulWidget {
  const UpdateTodolist({
    Key? key,
    required this.v3,
    required this.v1,
    required this.v2,
  }) : super(key: key);

  final v1, v2, v3;

  @override
  _UpdateTodolistState createState() => _UpdateTodolistState();
}

class _UpdateTodolistState extends State<UpdateTodolist> {
  var _v1, _v2, _v3;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController detailscontroller = TextEditingController();
  bool change = false;

  final snackBar = const SnackBar(
    content: Text('Changed success'),
    backgroundColor: Colors.green,
  );
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _v1 = widget.v1;
    _v2 = widget.v2;
    _v3 = widget.v3;
    titlecontroller.text = _v2;
    detailscontroller.text = _v3;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'fix Todolist',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                deleteTodolist(_v1);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_forever_rounded),
              color: Colors.red,
              iconSize: 35,
            )
          ],
          backgroundColor: lightercolor,
        ),
        backgroundColor: backgroundcolor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(16)),
                  TextFormField(
                    validator:
                        RequiredValidator(errorText: 'please fill title'),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.library_add),
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    controller: titlecontroller,
                    onChanged: (titlecontroller) {
                      if (titlecontroller != _v2) {
                        setState(() {
                          change = true;
                        });
                      }
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.list),
                      hintText: 'details...',
                      border: OutlineInputBorder(),
                      helperMaxLines: 2,
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    controller: detailscontroller,
                    onChanged: (detail) {
                      if (detail != _v3.toString()) {
                        setState(() {
                          change = true;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: change == true
                            ? () async {
                                if (_formkey.currentState!.validate()) {
                                  updateTodolist(_v1, titlecontroller.text,
                                      detailscontroller.text);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            : () {},
                        child: const Text(
                          'Confirm changed',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                change ? Colors.green : Colors.grey))),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future updateTodolist(int id, String title, String details) async {
    var url = Uri.http(apiAuthority, '/api/update-todolist/$id');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata = '{"title": "$title", "detail":"$details"}';
    await http.put(url, headers: header, body: jsondata);
  }

  Future deleteTodolist(int id) async {
    var url = Uri.http(apiAuthority, '/api/delete-todolist/$id');
    await http.delete(url);
  }

  // Future posttodolist(String title, String details) async {
  //   //https://1fba-101-109-241-27.ngrok.io/api/post-todolist
  //   var url = Uri.https('1fba-101-109-241-27.ngrok.io', '/api/post-todolist');
  //   Map<String, String> header = {"Content-type": "application/json"};
  //   String jsondata = '{"title": "$title","detail": "$details"}';
  //   print('jsondata: $jsondata');
  //   var response = await http.post(url, headers: header, body: jsondata);
  //   print(response.body);
  // }
}
