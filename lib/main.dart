import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/database.dart';
import 'package:todo/pages/todo.dart';
import 'package:todo/utilities/todolist.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/pages/todo.dart': (context) => ToDoPage(),
        // '/pages/todoedit.dart': (context) => ToDoEdit(index: 0),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


enum TaskFilter { All, Completed, Incomplete }

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  TaskFilter currentFilter = TaskFilter.All;
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.creteInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List filteredTasks = getFilteredTasks();

    return Scaffold(
      backgroundColor: Color(0xE5E8E2EA),
      appBar: AppBar(
        backgroundColor: Color(0xFF8761A4),
        title: Text('Список дел'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showFilterDialog(context);
            },
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? const Center(
        child: Text(
          'Список дел пуст',
          style: TextStyle(fontSize: 25, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return ToDoList(
            taskName: filteredTasks[index][0],
            taskDescription: filteredTasks[index][1],
            taskCompleted: filteredTasks[index][2],
            onChanged: (value) => checkBoxChanged(value, index),
            index: index,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ToDoPage()));
          if (result != null) {
            setState(() {});
          }
        },
        backgroundColor: Color(0xFF8761A4),
        child: const Icon(Icons.add),
      ),
    );
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][2] = !db.todoList[index][2];
    });
    db.updateDataBase();
  }

  void setFilter(TaskFilter filter) {
    setState(() {
      currentFilter = filter;
    });
  }

  List getFilteredTasks() {
    switch (currentFilter) {
      case TaskFilter.Completed:
        return db.todoList.where((task) => task[2]).toList();
      case TaskFilter.Incomplete:
        return db.todoList.where((task) => !task[2]).toList();
      case TaskFilter.All:
      default:
        return db.todoList.toList();
    }
  }

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Фильтр задач'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Все задачи',
                  style: currentFilter == TaskFilter.All
                      ? TextStyle(color: Color(0xFF8761A4))
                      : TextStyle(color: Colors.black),
                ),
                onTap: () {
                  setFilter(TaskFilter.All);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Выполненные',
                  style: currentFilter == TaskFilter.Completed
                      ? TextStyle(color: Color(0xFF8761A4))
                      : TextStyle(color: Colors.black),
                ),
                onTap: () {
                  setFilter(TaskFilter.Completed);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Невыполненные',
                  style: currentFilter == TaskFilter.Incomplete
                      ? TextStyle(color: Color(0xFF8761A4))
                      : TextStyle(color: Colors.black),
                ),
                onTap: () {
                  setFilter(TaskFilter.Incomplete);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

