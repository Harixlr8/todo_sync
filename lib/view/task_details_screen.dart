// view/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase/utils/colors.dart';
import 'package:todo_with_firebase/view_model/home_model.dart';
import 'package:todo_with_firebase/view_model/task_model.dart';
import 'package:todo_with_firebase/widgets/customTextfield.dart';
import '../model/todo_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final TodoModel todo;
  const TaskDetailScreen({super.key, required this.todo});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descController = TextEditingController(text: widget.todo.description);
    _isCompleted = widget.todo.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = Provider.of<HomeViewModel>(context);
    // final currentUser = viewModel.user?.email;
    final parentContext = context;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Detail"),
        actions: [
          Text("Delete task"),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text("Delete Task"),
                      content: Text(
                        "Are you sure you want to delete this task?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (shouldDelete ?? false) {
                final viewModel = Provider.of<HomeViewModel>(
                  context,
                  listen: false,
                );
                await viewModel.deleteTodo(widget.todo.id);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(controller: _titleController, labelText: "Task"),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _descController,
              labelText: "Description",
              isMultiline: true,
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: _isCompleted,
              onChanged: (val) {
                setState(() => _isCompleted = val ?? false);
              },
              title: const Text("Mark as Completed"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Created by: ${widget.todo.createdBy}"),
                const Spacer(),
                if (widget.todo.modifiedBy != null)
                  Text("Modified by: ${widget.todo.modifiedBy}"),
              ],
            ),
            const SizedBox(height: 20),
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
                    onPressed: () async {
                      final viewModel = context.read<HomeViewModel>();

                      final updatedTodo = widget.todo.copyWith(
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        isCompleted: _isCompleted,
                        modifiedBy: viewModel.user?.displayName, //
                      );

                      await viewModel.updateTodo(updatedTodo);
                      Navigator.pop(context); //
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: const Text("Save Changes"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors().primary,
        foregroundColor: Colors.white,
        onPressed: () {
          final userId =
              Provider.of<HomeViewModel>(
                parentContext,
                listen: false,
              ).user?.uid;
          if (userId != null) {
            _showShareUserListDialog(parentContext, widget.todo.id, userId);
          }
        },
        // child: Icon(Icons.share),
        label: Row(
          children: [Text("Share"), SizedBox(width: 10), Icon(Icons.share)],
        ),
      ),
    );
  }

  void _showShareUserListDialog(
    BuildContext parentContext,
    String todoId,
    String currentUserId,
  ) async {
    final getTaskModel = context.read<TaskDetailModel>();
    final users = await getTaskModel.getAllOtherUsers(currentUserId);

    showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select user to share with"),
          content: SizedBox(
            width: double.maxFinite,
            child:
                users.isEmpty
                    ? const Text("No other users found.")
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['email'] ?? ''),
                          onTap: () async {
                            await Provider.of<HomeViewModel>(
                              parentContext,
                              listen: false,
                            ).shareTodoWithUser(todoId, user['uid']!);

                            Navigator.pop(context);

                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text("Shared with ${user['email']}"),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
