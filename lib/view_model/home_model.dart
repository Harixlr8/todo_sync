// viewmodel/home_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/todo_model.dart';

class HomeViewModel extends ChangeNotifier {
  User? _user;
  List<TodoModel> _todos = [];
  bool _isLoadingUser = false;
  bool _isLoadingTodos = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _user;
  List<TodoModel> get todos => _todos;

  bool get isLoadingUser => _isLoadingUser;
  bool get isLoadingTodos => _isLoadingTodos;

  void _setLoadingUser(bool value) {
    _isLoadingUser = value;
    notifyListeners();
  }

  void _setLoadingTodos(bool value) {
    _isLoadingTodos = value;
    notifyListeners();
  }

  void loadUser() {
    _setLoadingUser(true);
    _user = _auth.currentUser;
    _setLoadingUser(false);
  }

  Future<void> fetchTodos() async {
    _setLoadingTodos(true);
    final currentUserId = _user?.uid;
    if(currentUserId == null) return ;


    try {
      final ownedSnapshot = await _firestore
          .collection('todos')
          .where('userId', isEqualTo: _user?.uid)
          .get();

          final sharedSnapshot = await _firestore.collection("todos").where('sharedWith' , arrayContains: currentUserId).get();

      _todos = [
        ...ownedSnapshot.docs,
        ...sharedSnapshot.docs,
      ].map((doc) {
        return TodoModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching todos: $e");
    }
    _setLoadingTodos(false);
  }
Future<void> addTodo(String title, String description) async {
  if (_user == null) return;

  final docRef = await _firestore.collection('todos').add({
  'title': title,
  'description': description,
  'isCompleted': false,
  'createdBy': _user!.displayName,
  'modifiedBy': null,
  'modifiedAt': null,
  'sharedWith': [],
  'userId': _user!.uid,
});

  final newTodo = TodoModel(
    id: docRef.id,
    title: title,
    description: description,
    createdBy: _user!.displayName ?? 'Unknown',
  );

  _todos.add(newTodo);
  notifyListeners();
}

Future<void> updateTodo(TodoModel updatedTodo) async {
  try {
    _isLoadingUser = true;
    notifyListeners();

    final modifiedTodo = updatedTodo.copyWith(
      modifiedBy: _user!.displayName ?? _user!.uid,
      modifiedAt: DateTime.now(),
    );

    await _firestore
        .collection('todos')
        .doc(modifiedTodo.id)
        .update(modifiedTodo.toMap());

    final index = _todos.indexWhere((t) => t.id == modifiedTodo.id);
    if (index != -1) {
      _todos[index] = modifiedTodo;
    }

    notifyListeners();
  } catch (e) {
    print("Error updating todo: $e");
  } finally {
    _isLoadingUser = false;
    notifyListeners();
  }
}




Future<void> deleteTodo(String todoId) async {
  try {
    _isLoadingUser = true;
    notifyListeners();

    await FirebaseFirestore.instance.collection('todos').doc(todoId).delete();

    // Remove from local list
    _todos.removeWhere((todo) => todo.id == todoId);

    notifyListeners();
  } catch (e) {
    print('Error deleting todo: $e');
  } finally {
    _isLoadingUser = false;
    notifyListeners();
  }
}

Future<void>shareTodoWithUser(String todoId,String sharedUserId) async{

  try{
    final todoRef = await _firestore.collection('todos').doc(todoId);
  final snapShot = await todoRef.get();

  if(snapShot.exists){
    final data = snapShot.data() as Map<String , dynamic> ;
    List <dynamic> sharedWith = (data['sharedWith']?? []) as List<dynamic>;

    if(!sharedWith.contains(sharedUserId)){
      sharedWith.add(sharedUserId);

      await todoRef.update({'sharedWith' : sharedWith});
    }
  }
  }
  catch (e){
    print('Error Sharing $e');
  }
}

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _todos = [];
    notifyListeners();
  }
}
