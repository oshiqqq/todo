import 'package:flutter/material.dart';
import 'package:todo/data/database.dart';

class ToDoList extends StatefulWidget {
  String taskName;
  final bool taskCompleted;
  String taskDescription;
  final Function(bool?)? onChanged;
  final int index;

  ToDoList({
    required this.taskName,
    required this.taskDescription,
    required this.taskCompleted,
    required this.onChanged,
    required this.index,
  });

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ToDoDataBase db = ToDoDataBase();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(context, widget.index);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 8.0, right: 10.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Checkbox(value: widget.taskCompleted, onChanged: widget.onChanged, activeColor: Color(0xFF8761A4)),
              Text(widget.taskName, style: TextStyle(fontSize: 18, color: (widget.taskCompleted ? Color(0xFF8761A4) : Colors.black))),
              Spacer(),
              IconButton(
                onPressed: () {
                  _showEditDialog(context, widget.index);
                },
                icon: Icon(Icons.edit),
                iconSize: 20,
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(context, widget.index);
                },
                icon: Icon(Icons.delete),
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) async {
    titleController.text = widget.taskName;
    descriptionController.text = widget.taskDescription;

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Color(0xE5E8E2EA),
      context: context,
      builder: (context) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 50),
            child: Column(
              children: [
                Text('Редактирование дела', style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      hintText: 'Название дела',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      hintText: 'Описание дела',
                      border: InputBorder.none,
                    ),
                    maxLines: 6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF8761A4),
                        foregroundColor: Colors.white,
                      ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Отмена'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8761A4),
                        ),
                        onPressed: () {
                          _editTask(index);
                          Navigator.pop(context);
                        },
                        child: Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
      },
    );

    setState(() {});
  }

  void _editTask(int index) {
    String newTitle = titleController.text;
    String newDescription = descriptionController.text;

    setState(() {
      widget.taskName = newTitle;
      widget.taskDescription = newDescription;
    });

    db.todoList[index] = [newTitle, newDescription, widget.taskCompleted];
    db.updateDataBase();
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Удаление дела'),
          content: Text('Вы уверены, что хотите удалить это дело?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF8761A4),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8761A4),
              ),
              onPressed: () {
                _deleteTask(index);
                Navigator.pop(context);
              },
              child: Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    db.todoList.removeAt(index);
    db.updateDataBase();
    setState(() {
    });
  }

}
