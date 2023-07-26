import 'package:flutter/material.dart';
import 'package:task_sheet_app/data/localStorage.dart';
import 'package:task_sheet_app/main.dart';
import 'package:task_sheet_app/widgets/taskItem.dart';

import '../models/taskModel.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where((task) => task.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var nowTask = filteredList[index];
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
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: nowTask);
                },
                child: TaskItem(task: nowTask),
              );
            },
          )
        : const Center(
            child: Text('Aramanızla eşleşen bir görev yok'),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
