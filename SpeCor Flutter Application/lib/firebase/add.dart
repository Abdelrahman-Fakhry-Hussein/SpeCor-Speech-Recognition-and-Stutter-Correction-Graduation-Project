import 'package:specor/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
class Firebase_Add{
  add_user(id,User_model user_model)async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    try {
      await ref.doc(id).set(user_model.to_json());
    } on Exception catch (e) {
      Get.snackbar("sorry", e.toString());
    }
  }}