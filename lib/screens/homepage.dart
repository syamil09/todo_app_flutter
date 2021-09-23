import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app_flutter/database_helper.dart';
import 'package:todo_app_flutter/screens/taskpage.dart';
import 'package:todo_app_flutter/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          color: const Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          child: const Image(
                            image: AssetImage('assets/images/logo.png'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'TODO APP',
                                style: TextStyle(
                                  color: Color(0xFF7349FE),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTasks(),
                          builder: (context, snapshot) {
                            List dataList = snapshot.data as List;
                            return ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    print(dataList[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                          task: dataList[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: dataList[index].title,
                                    description: dataList[index].description,
                                  ),
                                );
                              },
                            );
                          },
                        )),
                  )
                ],
              ),
              Positioned(
                bottom: 20,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Taskpage(task: null),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:
                        Image(image: AssetImage('assets/images/add_icon.png')),
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
