import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';
import 'add_edit_task.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  void _updateTaskStatus(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atualizar Tarefa'),
          content: Text('Deseja marcar esta tarefa como "Concluída" ou "Pendente"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Concluída'),
              onPressed: () {
                setState(() {
                  task.isCompleted = true;
                  task.save();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Pendente'),
              onPressed: () {
                setState(() {
                  task.isCompleted = false;
                  task.save();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskPage(task: task),
      ),
    );
  }

  void _deleteTask(Task task) {
    task.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<Task>>(
              valueListenable: taskBox.listenable(),
              builder: (context, box, _) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma tarefa adicionada',
                      style: TextStyle(color: Colors.green), // Texto verde
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      Task task = box.getAt(index)!;
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_box,
                                color: task.isCompleted ? Colors.green : Colors.red, // Cor verde quando concluída, vermelha quando pendente
                              ),
                              onPressed: () => _updateTaskStatus(task),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editTask(task),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTask(task),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor azul do botão
                minimumSize: Size(200, 50), // Tamanho mínimo do botão
                textStyle: TextStyle(
                  color: Colors.white, // Cor branca do texto
                  fontWeight: FontWeight.bold, // Texto em negrito
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditTaskPage()),
                );
              },
              child: Text(
                'Adicionar Tarefa',
                style: TextStyle(
                  color: Colors.white, // Cor branca do texto
                  fontWeight: FontWeight.bold, // Texto em negrito
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Espaçamento abaixo do botão
        ],
      ),
    );
  }
}
