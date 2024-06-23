import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_page.dart';


class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List<dynamic> _todos = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TO DO LIST"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text("ADD TODO"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(child: Text("Failed to load todos"))
          : _todos.isEmpty
          ? const Center(child: Text("No todos available"))
          : RefreshIndicator(
        onRefresh: fetchTodo,
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            final todo = _todos[index] as Map;
            final id = todo['_id'] as String;
            return ListTile(
              leading: CircleAvatar(child: Text("${index + 1}")),
              title: Text(todo['title'] ?? 'No Title'),
              subtitle: Text(todo['description'] ?? 'No Description'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") {
                    navigateToEditPage(todo);

                    // Handle edit
                  } else if (value == "delete") {
                    deleteById(id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: "edit",
                      child: Text("Edit"),
                    ),
                    const PopupMenuItem<String>(
                      value: "delete",
                      child: Text("Delete"),
                    ),
                  ];
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void navigateToEditPage(Map todo) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToPage(product: todo),
    );
    final result = await Navigator.push(context, route);
    if (result == true) {
      fetchTodo(); // Refresh the list if edit was successful
    }
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddToPage());
    final result = await Navigator.push(context, route);
    if (result == true) {
      fetchTodo(); // Refresh the list if add was successful
    }
  }

  Future<void> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = _todos.where((element) => element['_id'] != id).toList();
      setState(() {
        _todos = filtered;
      });
    } else {
      showErrorMessage("Deleting Failed");
    }
  }

  Future<void> fetchTodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _todos = jsonResponse['items'] ?? [];
          _isLoading = false;
          _hasError = false; // Reset error state on successful fetch
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
