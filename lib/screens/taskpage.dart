import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/database_helper.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'package:todo_app_flutter/screens/homepage.dart';
import 'package:todo_app_flutter/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task? task;
  const Taskpage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  int? _taskId = 0;
  String? _taskTitle = "";
  String? _taskDescription = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;
  bool _contentVisile = false;
  @override
  void initState() {
    if (widget.task != null) {
      _contentVisile = true;
      _taskId = widget.task!.id!;
      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;

      print(_taskTitle);
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _todoFocus!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /** Title task **/
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              // check the textField is not empty
                              if (value != '') {
                                // check if task is null then insert the value
                                if (widget.task == null) {
                                  Task _newTask = Task(
                                    title: value,
                                  );
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisile = true;
                                    _taskTitle = value;
                                  });
                                  print(
                                      '=======> new task has been created. <=========');
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId!, value);
                                  print('=====> data updated <=====');
                                }

                                _descriptionFocus?.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle ?? "",
                            decoration: const InputDecoration(
                              hintText: 'Enter Task Title',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  /** Description task **/
                  Visibility(
                    visible: _contentVisile,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value.isNotEmpty) {
                            if (_taskId != 0) {
                              DatabaseHelper _dbHelper = DatabaseHelper();
                              await _dbHelper
                                  .updateTaskDescription(_taskId!, value)
                                  .then((value) {
                                print(
                                    "=======> description of task has been updated <=======");
                              });
                            }
                          }
                          _todoFocus!.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription ?? "",
                        decoration: const InputDecoration(
                            hintText: 'Enter description for the task..',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24)),
                      ),
                    ),
                  ),

                  /** Add Todo **/
                  Visibility(
                    visible: _contentVisile,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 20.0,
                                height: 20.0,
                                margin: const EdgeInsets.only(
                                  right: 12.0,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        color: Color(0xFF86829D), width: 1.5)),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/check_icon.png'),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _todoFocus,
                                  controller: TextEditingController()
                                    ..text = "",
                                  decoration: const InputDecoration(
                                    hintText: 'Input Todo item...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              /** Button delete **/
              Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Taskpage(
                          task: null,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFE3577),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                        image: AssetImage('assets/images/delete_icon.png')),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
