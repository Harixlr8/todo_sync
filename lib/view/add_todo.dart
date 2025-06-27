// view/add_todo_screen.dart
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/utils/colors.dart';
import 'package:todo_with_firebase/widgets/customTextfield.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _taskController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add To-Do")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: _taskController,
              labelText: "Enter your task",
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              labelText: "Enter your task description",
              isMultiline: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, [
                        _taskController.text,
                        _descriptionController.text,
                      ]);
                    },
                    child: const Text("Add New Task"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
