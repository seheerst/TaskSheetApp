import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../models/taskModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allTask = <Task>[];
    _allTask.add(Task.create(name: 'deneme', createdAt: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              _showButtonAddTask(context);
            },
            child: const Text(
              'Bugün neler yapacaksın? ',
              style: TextStyle(color: Colors.black),
            )),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showButtonAddTask(context);
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
                    Icon(Icons.delete, color: Colors.grey,),
                    SizedBox(width: 10,),
                    Text('Bu Görev Silinecek'),
                  ],),
                  key: Key(nowTask.id),
                  onDismissed: (direction) {
                    _allTask.removeAt(index);
                    setState(() {});
                  },
                  child: ListTile(
                    //  leading: Text(nowTask.id),
                    title: Text(nowTask.name),
                    subtitle: Text(nowTask.createdAt.toString()),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Henüz görev eklemedin, \n        Hadi başlayalım'),
            ),
    );
  }

  void _showButtonAddTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Görevin Nedir?',
                ),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    Navigator.of(context).pop();
                    DatePicker.showTimePicker(context, showSecondsColumn: false,
                        onConfirm: (time) {
                      var newTask = Task.create(name: value, createdAt: time);

                      _allTask.add(newTask);
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
}
