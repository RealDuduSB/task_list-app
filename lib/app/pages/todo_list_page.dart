import 'package:flutter/material.dart';
import 'package:task_list/app/models/todo.dart';
import 'package:task_list/app/widgets/task_list_item.dart';
import 'package:task_list/repositories/todo_repository.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController taskController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tasks = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex. Estudar Flutter',
                            errorText: errorText,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.lightBlueAccent,
                              width: 3,
                            )),
                            labelStyle:
                                TextStyle(color: Colors.lightBlueAccent)),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          String text = taskController.text;

                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'Favor informar uma tarefa';
                            });
                            return;
                          }

                          setState(() {
                            Todo newTodo =
                                Todo(title: text, dateTime: DateTime.now());
                            tasks.add(newTodo);
                            errorText = null;
                          });
                          taskController.clear();
                          todoRepository.saveTodoList(tasks);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent,
                            padding: EdgeInsets.all(14)),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ))
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final Todo todo in tasks)
                        TaskListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text('Você possui ${tasks.length} tarefas pendentes'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: showDeleteTodosConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent,
                            padding: EdgeInsets.all(14)),
                        child: Text("Limpar tudo"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });
    todoRepository.saveTodoList(tasks);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.black,
        onPressed: () {
          setState(() {
            tasks.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(tasks);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              content:
                  Text('Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteAllTodos();
                    },
                    child: Text(
                      'Limpar tudo',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }

  void deleteAllTodos() {
    setState(() {
      tasks.clear();
    });
    todoRepository.saveTodoList(tasks);
  }
}

/*

class TaskPage extends StatefulWidget {
  TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _controller = TaskController();
  List<String> tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller.taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Ex. Estudar Flutter',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        String text = _controller.taskController.text;
                        tasks.add(text);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          padding: EdgeInsets.all(14)),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ))
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for(String todo in tasks)
                    ListTile(
                      title: Text(tasks),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Você possui 0 tarefas pendentes'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlueAccent,
                          padding: EdgeInsets.all(14)),
                      child: Text("Limpar tudo"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
