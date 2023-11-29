import 'package:hive/hive.dart';

class ToDoDataBase {
  static final ToDoDataBase _instance = ToDoDataBase._internal();

  factory ToDoDataBase() {
    return _instance;
  }

  ToDoDataBase._internal();

  List todoList = [];
  final _myBox = Hive.box('mybox');

  void creteInitialData() {
    todoList = [
      ['Task 1', 'Description for Task 1', false],
      ['Task 2', 'Description for Task 2', false],
    ];
    updateDataBase();
  }

  void loadData() {
    todoList = _myBox.get('TODOLIST') ?? [];
    print('Data Loaded: $todoList');
  }

  void updateDataBase() {
    _myBox.put('TODOLIST', todoList);
    print('Data updated: $todoList');
  }

  void addTask(String title, String description) {
    todoList.add([title, description, false]);
    print('Data add: $todoList');
  }
}
