import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoprovider/pages/todo_page.dart';
import 'package:todoprovider/providers/active_todo_count.dart';
import 'package:todoprovider/providers/filtered_todos.dart';
import 'package:todoprovider/providers/todo_filter.dart';
import 'package:todoprovider/providers/todo_list.dart';
import 'package:todoprovider/providers/todo_search.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoFilter>(create: (context) => TodoFilter(),),
        ChangeNotifierProvider<TodoSearch>(create: (context) => TodoSearch(),),
        ChangeNotifierProvider<TodoList>(create: (context) => TodoList(),),
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(
            initialActiveTodoCount: context.read<TodoList>().state.todos.length,
          ),
          update: ( BuildContext context, TodoList todoList, ActiveTodoCount? activeTodoCount,
          ) => activeTodoCount!..update(todoList), ),

        ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList,FilteredTodos>(
          create: (context) => FilteredTodos( initialFilteredTodos: context.read<TodoList>().state.todos, ),
          update: (
            BuildContext context,
            TodoFilter todoFilter,
            TodoSearch todoSearch,
            TodoList todoList,
            FilteredTodos? filteredTodos,
          ) =>
              filteredTodos!..update(todoFilter, todoSearch, todoList),
        ),
      ],
      child: MaterialApp(
        title: 'TODOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodoScreen(),
      ),
    );
  }
}