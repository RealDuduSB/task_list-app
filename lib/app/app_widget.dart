import 'package:flutter/material.dart';
import 'package:task_list/app/pages/todo_list_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
