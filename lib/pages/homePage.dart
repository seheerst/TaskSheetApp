import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:task_sheet_app/data/localStorage.dart';
import 'package:task_sheet_app/main.dart';
import 'package:task_sheet_app/widgets/customSearchDelegate.dart';
import 'package:task_sheet_app/widgets/taskItem.dart';

import '../models/taskModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              _showButtonAddTask();
            },
            child: const Text(
              'Bugün neler yapacaksın? ',
              style: TextStyle(color: Colors.black),
            )),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {
            _showSearchPage();
          }, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showButtonAddTask();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                var nowTask = _allTask[index];
                return Dismissible(
                  background: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Bu Görev Silinecek'),
                    ],
                  ),
                  key: Key(nowTask.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    _localStorage.deleteTask(task: nowTask);
                    setState(() {});
                  },
                  child: TaskItem(task: nowTask),
                );
              },
            )
          : const Center(
              child: Text('Henüz görev eklemedin, \n\t Hadi başlayalım'),
            ),
    );
  }

  void _showButtonAddTask() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Görevin Nedir?',
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.of(context).pop();
                    DatePicker.showTimePicker(context, showSecondsColumn: false,
                        onConfirm: (time) async {
                      var newTask = Task.create(name: value, createdAt: time);

                      _allTask.insert(0, newTask);
                      await _localStorage.addTask(task: newTask);
                      setState(() {});
                    });
                  }
                  //dtp.DatePicker.showTimePicker(context);
                },
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async{
     await showSearch(context: context, delegate: CustomSearchDelegate(allTask: _allTask));
     _getAllTaskFromDb();
  }
}
