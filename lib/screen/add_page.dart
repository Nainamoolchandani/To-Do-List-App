import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToPage extends StatefulWidget {
  final Map? product;
  const AddToPage({super.key, this.product});

  @override
  State<AddToPage> createState() => _AddToPageState();
}

class _AddToPageState extends State<AddToPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      isEdit = true;
      final title = product["title"];
      final description = product["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Page" : "Add To Page"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? "Update" : "Submit"))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      showErrorMessage("Title and description can't be empty");
      return;
    }

    final body = {
      "title": title,
      "description": description,
      "is_completed": widget.product?['is_completed'] ?? false
    };

    final url = "https://api.nstack.in/v1/todos/${widget.product?['_id']}";
    final uri = Uri.parse(url);
    try {
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        titleController.clear();
        descriptionController.clear();
        showSuccessMessage("Update Successful");
        Navigator.pop(context, true); // Return to the previous screen with a success flag
      } else {
        showErrorMessage("Update Failed");
      }
    } catch (e) {
      print('Error updating data: $e');
      showErrorMessage("Update Failed");
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      showErrorMessage("Title and description can't be empty");
      return;
    }

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 201) {
        titleController.clear();
        descriptionController.clear();
        showSuccessMessage("Creation Successful");
        Navigator.pop(context, true); // Return to the previous screen with a success flag
      } else {
        showErrorMessage("Creation Failed");
      }
    } catch (e) {
      print('Error submitting data: $e');
      showErrorMessage("Creation Failed");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchTodo() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Handle fetched data as needed
      } else {
        showErrorMessage("Failed to fetch todos");
      }
    } catch (e) {
      print('Error fetching data: $e');
      showErrorMessage("Failed to fetch todos");
    }
  }
}
