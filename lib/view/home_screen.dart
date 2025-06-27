// view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase/utils/colors.dart';
import 'package:todo_with_firebase/view/add_todo.dart';
import 'package:todo_with_firebase/view/login_screen.dart';
import 'package:todo_with_firebase/view/task_details_screen.dart';
import 'package:todo_with_firebase/view_model/home_model.dart';
import 'package:todo_with_firebase/view_model/task_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  showLogoutALert(String user, BuildContext context, HomeViewModel viewModel) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text("Log out for User $user"),
          const Text("Are you sure you want to log out?"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await viewModel.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text("Logout"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = HomeViewModel();
        viewModel.loadUser();
        viewModel.fetchTodos();
        return viewModel;
      },
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoadingUser || viewModel.isLoadingTodos) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = viewModel.user;
          final todos = viewModel.todos;

          return Scaffold(
            appBar: AppBar(
              title: const Text('To-Do App'),
              actions: [
                Text(user?.displayName ?? "User"),
                IconButton(
                  icon: const Icon(Icons.power_settings_new),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => showLogoutALert(
                            user!.displayName ?? "User",
                            context,
                            viewModel,
                          ),
                    );
                  },
                ),
              ],
            ),
            body:
                todos.isEmpty
                    ? const Center(child: Text("No tasks added yet."))
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider.value(
                                          value: Provider.of<HomeViewModel>(
                                            context,
                                            listen: false,
                                          ),
                                        ),
                                        ChangeNotifierProvider(
                                          create: (_) => TaskDetailModel(),
                                        ),
                                      ],
                                      child: TaskDetailScreen(todo: todo),
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                todo.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  todo.description,
                                  style: const TextStyle(color: Colors.white70),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: Icon(
                                todo.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors().primary,
              heroTag: UniqueKey(),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTodoScreen()),
                );
                if (result != null && result.length == 2) {
                  final title = result[0].trim();
                  final description = result[1].trim();
                  try {
                    if (title.isNotEmpty && description.isNotEmpty) {
                      viewModel.addTodo(title, description);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful!')),
                    );
                  }
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
