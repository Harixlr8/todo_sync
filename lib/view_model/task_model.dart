import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskDetailModel extends ChangeNotifier{
  User? _user;
  bool _isLoading = false;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? get user => _user;
  bool get isLoading => _isLoading;

 

  Future<List<Map<String, dynamic>>> getAllOtherUsers(String currentUserId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isNotEqualTo: currentUserId)
      .get();

  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    return {
      'uid': data['uid'],
      'email': data['email'],
    };
  }).toList();
}

}