import 'package:flutter/material.dart';

import 'database_helper.dart';

class TodoListApp extends StatefulWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  State<TodoListApp> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  String todoEdited = "";
  final dbHelper = DatabaseHelper.instance;
  final todoController = TextEditingController();
  bool validated = true ;
  String errorMessage = "";
  var myTodos = [];
  List<Widget> children = [];
  bool moreOptions = false;
  Map<String, dynamic> uTodo ={'x':'xx'} ;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snap) {
      if (snap.hasData == null) {
        return const Center(
          child: Text("NO DATA"),
        );
      } else {
        if (myTodos.length == 0) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Todos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: Text(
                "No Tasks Available",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: showAlertDialog,
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add),
            ),
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "My Todos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: showAlertDialog,
              backgroundColor: Colors.purple,
              child: const Icon(Icons.add),
            ),
          );
        }
      }
    },future: queryAllTodosInTable(),);
  }

  void insertTodo() async {
    Map<String, dynamic> todo = {
      DatabaseHelper.columnName: todoEdited,
    };
    final id = await dbHelper.insert(todo);
    print(id);
    Navigator.of(context,rootNavigator: true).pop();
    todoEdited = "";
    setState((){
      validated = true;
      errorMessage = "";
    });

  }

  void showAlertDialog() {
    todoController.text="";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Todo"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: todoController,
                    autofocus: true,
                    onChanged: (value) {
                      todoEdited = value;
                    },
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      errorText: validated ? null : errorMessage,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    color: Colors.purple,
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (todoController.text.isEmpty) {
                        setState(() {
                          errorMessage = "Cannot be Empty";
                          validated = false;
                        });
                      } else if (todoController.text.length > 500) {
                        setState(() {
                          errorMessage = "Too Many Characters";
                          validated = false;
                        });
                      } else {
                        insertTodo();
                      }
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  Future queryAllTodosInTable() async {
    myTodos =[];
    children=[];
    var allTodos = await dbHelper.queryAllTodos();
    allTodos?.forEach((todo) {
      myTodos.add(todo.toString());
      children.add(InkWell(
        onLongPress: () {
          setState(() {
            moreOptions = !moreOptions;
          });
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 7,vertical: 3),
          elevation: 5,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(todo['todo'],style: TextStyle(fontSize: 16),),
               ),
               moreOptions? 
    Row(
      children: [
        IconButton(onPressed: (){
          setState(() {
            dbHelper.delete(todo['_id']);
            moreOptions = !moreOptions;
          });
        }, icon: Icon(Icons.delete,),color: Colors.red,),
        IconButton(onPressed: (){
          showAlertDialogUpdate(todo);
        }, icon: Icon(Icons.edit,),color: Colors.blue,),
      ],
    )
     : Text(''),
            ],
          ) ,
            ), ),
      ));
    });
  }
  
  void showAlertDialogUpdate(Map<String, dynamic> todo) {
    todoController.text="";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Todo"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: todoController,
                    autofocus: true,
                    onChanged: (value) {
                      todoEdited = value;
                    },
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      errorText: validated ? null : errorMessage,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    color: Colors.purple,
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (todoController.text.isEmpty) {
                        setState(() {
                          errorMessage = "Cannot be Empty";
                          validated = false;
                        });
                      } else if (todoController.text.length > 500) {
                        setState(() {
                          errorMessage = "Too Many Characters";
                          validated = false;
                        });
                      } else {
                        uTodo.clear();
                        uTodo.addAll({'_id':todo['_id'], 'todo':todoController.text});
                        updateTodo(uTodo);
                      }
                    },
                  ),
                ],
              ),
            );
          });
        });
  }
  
  void updateTodo(Map<String, dynamic> todo) {
    setState(() {
      dbHelper.updateMyTodo(todo);
      moreOptions = !moreOptions;
      });
    Navigator.of(context,rootNavigator: true).pop();
  }
}
