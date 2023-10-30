import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 194, 233),
        title: Text('To-Do App'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].task),
            subtitle: Text(todos[index].dueDateTime),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _removeTodoItem(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoItem();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem() async {
    final TextEditingController textController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new To-Do'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      selectedDate = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  }
                },
                child: Text('Select Due Date & Time'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  final newItem =
                      TodoItem(textController.text, selectedDate.toString());
                  _addTodoItemToFirestore(newItem);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItemToFirestore(TodoItem item) {
    _firestore.collection('todos').add({
      'task': item.task,
      'dueDateTime': item.dueDateTime,
    });
  }

  void _removeTodoItem(int index) {
    final todo = todos[index];
    todos.removeAt(index);
    // Find the document with the same task and dueDateTime in Firestore and delete it
    _firestore
        .collection('todos')
        .where('task', isEqualTo: todo.task)
        .where('dueDateTime', isEqualTo: todo.dueDateTime)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTodoItems();
  }

  void _fetchTodoItems() async {
    final querySnapshot = await _firestore.collection('todos').get();
    setState(() {
      todos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TodoItem(data['task'], data['dueDateTime']);
      }).toList();
    });
  }
}

class TodoItem {
  final String task;
  final String dueDateTime;

  TodoItem(this.task, this.dueDateTime);
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TodoListScreen(),
//     );
//   }
// }

// class TodoListScreen extends StatefulWidget {
//   @override
//   _TodoListScreenState createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen> {
//   List<TodoItem> todos = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 147, 194, 233),
//         title: Text('To-Do App'),
//       ),
//       body: ListView.builder(
//         itemCount: todos.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(todos[index].task),
//             subtitle: Text(todos[index].dueDateTime),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 setState(() {
//                   todos.removeAt(index);
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addTodoItem();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _addTodoItem() async {
//     final TextEditingController textController = TextEditingController();
//     DateTime selectedDate = DateTime.now();

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add a new To-Do'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 controller: textController,
//                 decoration: InputDecoration(labelText: 'Task'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (picked != null) {
//                     final TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (pickedTime != null) {
//                       selectedDate = DateTime(
//                         picked.year,
//                         picked.month,
//                         picked.day,
//                         pickedTime.hour,
//                         pickedTime.minute,
//                       );
//                     }
//                   }
//                 },
//                 child: Text('Select Due Date & Time'),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 setState(() {
//                   todos.add(
//                     TodoItem(textController.text, selectedDate.toString()),
//                   );
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class TodoItem {
//   final String task;
//   final String dueDateTime;

//   TodoItem(this.task, this.dueDateTime);
// }





























// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:todo/home.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "title:ToDo App",
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Home(),
//     );
//   }
// }
