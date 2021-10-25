import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import '../const.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController titlecontroller = TextEditingController();
    TextEditingController detailscontroller = TextEditingController();
    return Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          title: Text(
            'Create Todolist',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: darkcolor,
        ),
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
                        RequiredValidator(errorText: 'please fill tiltle'),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.library_add),
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    controller: titlecontroller,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          posttodolist(
                              titlecontroller.text, detailscontroller.text);
                          setState(() {
                            titlecontroller.clear();
                            detailscontroller.clear();
                          });
                        }
                      },
                      child: const Text(
                        'create',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(primary: secondarycolor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future posttodolist(String title, String details) async {
    //https://1fba-101-109-241-27.ngrok.io/api/post-todolist
    var url = Uri.http(apiAuthority, '/api/post-todolist');
    Map<String, String> header = {"Content-type": "application/json"};
    String jsondata = '{"title": "$title","detail": "$details"}';
    await http.post(url, headers: header, body: jsondata);
  }
}
