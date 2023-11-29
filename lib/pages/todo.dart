import 'package:flutter/material.dart';
import 'package:todo/data/database.dart';

class ToDoPage extends StatefulWidget {

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late ToDoDataBase db;
  @override
  void initState() {
    db = ToDoDataBase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5E8E2EA),
      appBar: AppBar(
        backgroundColor: Color(0xFF8761A4),
        title: Text('Создание дела'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8761A4),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  String title = titleController.text;
                  String description = descriptionController.text;
                    if (title.isNotEmpty && description.isNotEmpty) {
                      setState(() {
                    db.addTask(title, description);
                    db.updateDataBase();
                    db.loadData();
                      });
                    Navigator.pop(context, true);
                    } else {
                  }
                },
                child: Text('Сохранить дело'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
