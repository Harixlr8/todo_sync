// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:todo_with_firebase/model/user_model.dart';
import 'package:todo_with_firebase/services/firebase_auth_service.dart';
import 'package:todo_with_firebase/view/home_screen.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final fireBaseService = FirebaseService();

  final formKey = GlobalKey<FormState>();

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateUser(String? value) {
    if (value == null || value.isEmpty) return 'Username is mandatory';
    return null;
  }

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      try {
        final user = await fireBaseService.signInWithEmail(
          emailController.text,
          passwordController.text,
        );
        if (user != null) {
          await saveUserToFireStore(user);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false, 
          );

        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setLoading(false);
      }
    }
  }

  void signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      try {
        final user = await fireBaseService.createUser(
          emailController.text.trim(),
          passwordController.text.trim(),
          displayNameController.text
              .trim(), 
        );
        if (user != null) {
          await saveUserToFireStore(user);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Signup successful!')));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false, 
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setLoading(false);
      }
    }
  }

  Future<void>saveUserToFireStore(User user)async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'email': user.email,
      "name": user.displayName,
      'uid': user.uid
    }).toString();
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
  }
}
