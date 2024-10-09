import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google-style Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Just Do It', style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Implement menu options here
            },
          ),
        ],
      ),
      body: _todos.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Add a task!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Checkbox(
                      value: _todos[index].isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          _todos[index].isDone = value!;
                        });
                      },
                      activeColor: Colors.blue[600],
                    ),
                    title: Text(
                      _todos[index].title,
                      style: TextStyle(
                        decoration: _todos[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey[600]),
                          onPressed: () => _editTodo(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey[600]),
                          onPressed: () => _deleteTodo(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        label: Text('Add a task'),
        icon: Icon(Icons.add),
      ),
    );
  }

  void _addTodo() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TodoDialog(title: 'Add a task'),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: result));
      });
    }
  }

  void _editTodo(int index) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TodoDialog(
        title: 'Edit task',
        initialValue: _todos[index].title,
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _todos[index].title = result;
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }
}

class _TodoDialog extends StatefulWidget {
  final String title;
  final String? initialValue;

  const _TodoDialog({Key? key, required this.title, this.initialValue})
      : super(key: key);

  @override
  __TodoDialogState createState() => __TodoDialogState();
}

class __TodoDialogState extends State<_TodoDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter task',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Save'),
          onPressed: () => Navigator.of(context).pop(_controller.text),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});
}
