import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/json_service.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addTodo() {
    final title = controller.text.trim();
    if (title.isEmpty) return;

    setState(() {
      todos.add(Todo(title: title));
    });

    controller.clear();
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].done = !todos[index].done;
    });
  }

  void exportJson() {
    final jsonData = JsonService.exportTodos(todos);
    debugPrint(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Backup App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: exportJson,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoItem(
                  todo: todo,
                  onTap: () => toggleTodo(index),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
